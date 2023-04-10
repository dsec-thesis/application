import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:smart_parking_app/controllers/markers.dart';
import 'package:uuid/uuid.dart';

import '../../utils/map_tools.dart';
import '../../utils/tools.dart';
import '../widgets/circle_area.dart';
import 'autocomplete_search.dart';
import 'autocomplete_search_controller.dart';
import 'google_maps_widget.dart';
import 'pick_result.dart';
import 'place_provider.dart';

typedef IntroModalWidgetBuilder = Widget Function(
  BuildContext context,
  Function? close,
);

class MapsPage extends StatefulWidget {
  const MapsPage({
    super.key,
    required this.apiKey,
    required this.initialPosition,
    this.useCurrentLocation,
    this.desiredLocationAccuracy = LocationAccuracy.high,
    this.autoCompleteDebounceInMilliseconds = 500,
    this.cameraMoveDebounceInMilliseconds = 750,
    this.initialMapType = MapType.normal,
    this.enableMapTypeButton = true,
    this.enableMyLocationButton = true,
    this.myLocationButtonCooldown = 10,
    this.usePinPointingSearch = true,
    this.usePlaceDetailSearch = false,
    this.selectInitialPosition = false,
    this.resizeToAvoidBottomInset = true,
    this.searchForInitialValue = false,
    this.forceAndroidLocationManager = false,
    this.forceSearchOnZoomChanged = false,
    this.automaticallyImplyAppBarLeading = true,
    this.autocompleteOnTrailingWhitespace = false,
    this.hidePlaceDetailsWhenDraggingPin = true,
    this.zoomGesturesEnabled = true,
    this.zoomControlsEnabled = false,
    this.onAutoCompleteFailed,
    this.onGeocodingSearchFailed,
    this.onMapCreated,
    this.onCameraIdle,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onMoveStart,
    this.onMapTypeChanged,
    this.pickArea,
    this.hintText,
    this.searchingText,
    this.selectText,
    this.outsideOfPickAreaText,
    this.onPlacePicked,
    this.introModalWidgetBuilder,
    this.onTapBack,
    this.pinBuilder,
  });

  final String apiKey;
  final LatLng initialPosition;
  final bool? useCurrentLocation;
  final LocationAccuracy desiredLocationAccuracy;
  final MapCreatedCallback? onMapCreated;

  final int autoCompleteDebounceInMilliseconds;
  final int cameraMoveDebounceInMilliseconds;

  final MapType initialMapType;
  final bool enableMapTypeButton;
  final bool enableMyLocationButton;
  final int myLocationButtonCooldown;

  final bool usePinPointingSearch;
  final bool usePlaceDetailSearch;

  final bool selectInitialPosition;
  final bool resizeToAvoidBottomInset;

  final bool searchForInitialValue;
  final bool forceAndroidLocationManager;
  final bool forceSearchOnZoomChanged;
  final String? hintText;
  final String? searchingText;
  final String? selectText;
  final String? outsideOfPickAreaText;

  final bool automaticallyImplyAppBarLeading;
  final bool autocompleteOnTrailingWhitespace;
  final bool hidePlaceDetailsWhenDraggingPin;

  /// Allow user to make visible the zoom button & toggle on & off zoom gestures
  final bool zoomGesturesEnabled;
  final bool zoomControlsEnabled;

  final ValueChanged<String>? onAutoCompleteFailed;
  final ValueChanged<String>? onGeocodingSearchFailed;
  final Function(PlaceProvider)? onCameraIdle;
  final Function(PlaceProvider)? onCameraMoveStarted;
  final CameraPositionCallback? onCameraMove;
  final VoidCallback? onMoveStart;
  final ValueChanged<PickResult>? onPlacePicked;

  final Function(MapType)? onMapTypeChanged;
  final CircleArea? pickArea;
  final IntroModalWidgetBuilder? introModalWidgetBuilder;
  final VoidCallback? onTapBack;
  final PinBuilder? pinBuilder;

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GlobalKey appBarKey = GlobalKey();
  late final Future<PlaceProvider> _futureProvider;
  PlaceProvider? provider;
  SearchBarController searchBarController = Get.put(SearchBarController());
  bool showIntroModal = true;
  late MarkersProvider markerProvider;
  late Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _futureProvider = _initPlaceProvider(widget.apiKey);
    markerProvider = Get.put(MarkersProvider(widget.apiKey));
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  Future<PlaceProvider> _initPlaceProvider(String apiKey,
      [String? proxyBaseUrl, Client? httpClient]) async {
    final headers = await const GoogleApiHeaders().getHeaders();
    final provider = Get.put(
      PlaceProvider(
        apiKey = apiKey,
        proxyBaseUrl = proxyBaseUrl,
        httpClient = httpClient,
        headers,
      ),
    );
    provider.sessionToken = const Uuid().v4();
    provider.desiredAccuracy = widget.desiredLocationAccuracy;
    provider.setMapType(widget.initialMapType);
    if (widget.useCurrentLocation != null && widget.useCurrentLocation!) {
      await provider.updateCurrentLocation(widget.forceAndroidLocationManager);
    }

    return provider;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        searchBarController.clearOverlay();
        return Future.value(true);
      },
      child: FutureBuilder<PlaceProvider>(
        future: _futureProvider,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            provider = snapshot.data;

            return Stack(
              children: [
                Scaffold(
                  key: ValueKey<int>(provider.hashCode),
                  resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    key: appBarKey,
                    automaticallyImplyLeading: false,
                    iconTheme: Theme.of(context).iconTheme,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    titleSpacing: 0.0,
                    title: _buildSearchBar(context),
                  ),
                  body: _buildMapWithLocation(),
                ),
                _buildIntroModal(context),
              ],
            );
          }

          final children = <Widget>[];
          if (snapshot.hasError) {
            children.addAll([
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ]);
          } else {
            children.add(const CircularProgressIndicator());
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapWithLocation() {
    if (provider!.currentPosition == null) {
      return _buildMap(widget.initialPosition);
    }
    return _buildMap(LatLng(provider!.currentPosition!.latitude,
        provider!.currentPosition!.longitude));
  }

  Widget _buildMap(LatLng initialTarget) {
    return GoogleMapWidget(
      fullMotion: !widget.resizeToAvoidBottomInset,
      initialTarget: initialTarget,
      appBarKey: appBarKey,
      //selectedPlaceWidgetBuilder: widget.selectedPlaceWidgetBuilder,
      //pinBuilder: widget.pinBuilder,
      onGeocodingSearchFailed: widget.onGeocodingSearchFailed,
      debounceMilliseconds: widget.cameraMoveDebounceInMilliseconds,
      enableMapTypeButton: widget.enableMapTypeButton,
      enableMyLocationButton: widget.enableMyLocationButton,
      usePinPointingSearch: widget.usePinPointingSearch,
      usePlaceDetailSearch: widget.usePlaceDetailSearch,
      onMapCreated: widget.onMapCreated,
      selectInitialPosition: widget.selectInitialPosition,
      //language: widget.autocompleteLanguage,
      pickArea: widget.pickArea,
      forceSearchOnZoomChanged: widget.forceSearchOnZoomChanged,
      hidePlaceDetailsWhenDraggingPin: widget.hidePlaceDetailsWhenDraggingPin,
      selectText: widget.selectText,
      outsideOfPickAreaText: widget.outsideOfPickAreaText,
      onToggleMapType: () {
        provider!.switchMapType();
        if (widget.onMapTypeChanged != null) {
          widget.onMapTypeChanged!(provider!.mapType);
        }
      },
      onMyLocation: _onLocationPressed,
      onMoveStart: () {
        searchBarController.reset();
      },
      markers: markers,
      onPlacePicked: _onPlacePickedPressed, //widget.onPlacePicked,
      onCameraMoveStarted: widget.onCameraMoveStarted,
      onCameraMove: widget.onCameraMove,
      onCameraIdle: widget.onCameraIdle,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      zoomControlsEnabled: widget.zoomControlsEnabled,
    );
  }

  void _onPlacePickedPressed(PickResult result) async {
    logger.i("lugar tocado");
    logger.i(result.geometry!.location);
    if (provider != null) {
      await markerProvider.updateMarkers(provider!.cameraPosition);
    }

    setState(() {
      markers = markerProvider.markers;
    });

    //setState(() {});
  }

  void _onLocationPressed() async {
    logger.d("adsdasdsadsadsadasdsadsa");
    // Prevent to click many times in short period.
    if (provider!.isOnUpdateLocationCooldown == false) {
      provider!.isOnUpdateLocationCooldown = true;
      Timer(Duration(seconds: widget.myLocationButtonCooldown), () {
        provider!.isOnUpdateLocationCooldown = false;
      });
      await provider!.updateCurrentLocation(widget.forceAndroidLocationManager);

      if (distanceBetween(
              provider!.cameraPosition!.target,
              LatLng(provider!.currentPosition!.latitude,
                  provider!.currentPosition!.longitude)) >
          50) {
        //FIX: esta es una distancia de 50 metros para que nos mueva el objetivo de la camara
        await _moveToCurrentPosition();
      }
    }
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: <Widget>[
        widget.automaticallyImplyAppBarLeading || widget.onTapBack != null
            ? IconButton(
                onPressed: () {
                  if (!showIntroModal ||
                      widget.introModalWidgetBuilder == null) {
                    if (widget.onTapBack != null) {
                      widget.onTapBack!();
                      return;
                    }
                    Navigator.maybePop(context);
                  }
                },
                icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                ),
                color: Colors.black.withAlpha(128),
                padding: EdgeInsets.zero)
            : const SizedBox(width: 15),
        Expanded(
          child: AutoCompleteSearch(
              appBarKey: appBarKey,
              searchBarController: searchBarController,
              sessionToken: provider!.sessionToken,
              debounceMilliseconds: widget.autoCompleteDebounceInMilliseconds,
              onPicked: (prediction) {
                _pickPrediction(prediction);
              },
              onSearchFailed: (status) {
                if (widget.onAutoCompleteFailed != null) {
                  widget.onAutoCompleteFailed!(status);
                }
              },
              searchForInitialValue: widget.searchForInitialValue,
              autocompleteOnTrailingWhitespace:
                  widget.autocompleteOnTrailingWhitespace),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  _pickPrediction(Prediction prediction) async {
    provider!.placeSearchingState = SearchingState.Searching;

    final PlacesDetailsResponse response =
        await provider!.places.getDetailsByPlaceId(
      prediction.placeId!,
      sessionToken: provider!.sessionToken,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      if (widget.onAutoCompleteFailed != null) {
        widget.onAutoCompleteFailed!(response.status);
      }
      return;
    }

    provider!.selectedPlace = PickResult.fromPlaceDetailResult(response.result);

    // Prevents searching again by camera movement.
    provider!.isAutoCompleteSearching = true;

    logger.i("la barra de direcciones carga el lugar");

    await _moveTo(provider!.selectedPlace!.geometry!.location.lat,
        provider!.selectedPlace!.geometry!.location.lng);

    provider!.placeSearchingState = SearchingState.Idle;
  }

  _moveTo(double latitude, double longitude) async {
    GoogleMapController? controller = provider!.mapController;
    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16,
        ),
      ),
    );
  }

  _moveToCurrentPosition() async {
    if (provider!.currentPosition != null) {
      await _moveTo(provider!.currentPosition!.latitude,
          provider!.currentPosition!.longitude);
    }
  }

  Widget _buildIntroModal(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return showIntroModal && widget.introModalWidgetBuilder != null
            ? Stack(
                children: const [
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    left: 0,
                    child: Material(
                      type: MaterialType.canvas,
                      color: Color.fromARGB(128, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: ClipRect(),
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }
}
