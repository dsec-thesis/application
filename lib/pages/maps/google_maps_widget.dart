import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:tuple/tuple.dart';

import '../../utils/tools.dart';
import '../widgets/animated_ping.dart';
import '../widgets/circle_area.dart';
import '../widgets/floating_card.dart';
import 'pick_result.dart';
import 'place_provider.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  PickResult? selectedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({
    super.key,
    required this.initialTarget,
    required this.appBarKey,
    this.zoomGesturesEnabled = true,
    this.zoomControlsEnabled = false,
    this.enableMyLocationButton = false,
    this.compassEnabled = false,
    this.mapToolbarEnabled,
    this.onToggleMapType,
    this.mapType,
    this.myLocationEnabled = true,
    this.onMapCreated,
    this.selectInitialPosition,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.pickArea,
    this.markers,
    required this.fullMotion,
    this.onGeocodingSearchFailed,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.forceSearchOnZoomChanged,
    this.hidePlaceDetailsWhenDraggingPin,
    this.selectText,
    this.outsideOfPickAreaText,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMyLocation,
    this.onPlacePicked,
    this.pinBuilder,
    this.selectedPlaceWidgetBuilder,
  });

  final LatLng initialTarget;
  final GlobalKey appBarKey;
  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final bool fullMotion;
  final bool zoomGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool? enableMyLocationButton;
  final bool? compassEnabled;
  final bool? mapToolbarEnabled;
  final VoidCallback? onToggleMapType;
  final MapType? mapType;
  final bool? myLocationEnabled;
  final MapCreatedCallback? onMapCreated;
  final bool? selectInitialPosition;
  final int? debounceMilliseconds;
  final bool? enableMapTypeButton;
  final bool? forceSearchOnZoomChanged;
  final bool? hidePlaceDetailsWhenDraggingPin;
  final String? selectText;
  final String? outsideOfPickAreaText;

  /// GoogleMap pass-through events:
  final Function(PlaceProvider)? onCameraMoveStarted;
  final CameraPositionCallback? onCameraMove;
  final Function(PlaceProvider)? onCameraIdle;
  final ValueChanged<String>? onGeocodingSearchFailed;
  final ValueChanged<String>? onSearchFailed;
  final VoidCallback? onMoveStart;
  final VoidCallback? onMyLocation;
  final ValueChanged<PickResult>? onPlacePicked;

  final bool? usePinPointingSearch;
  final bool? usePlaceDetailSearch;

  final CircleArea? pickArea;
  final Set<Marker>? markers;
  final PinBuilder? pinBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (!fullMotion)
          SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      _buildGoogleMap(context),
                      _buildPin(),
                    ],
                  ))),
        if (fullMotion) _buildGoogleMap(context),
        if (fullMotion) _buildPin(),
        _buildFloatingCard(),
        _buildMapIcons(context),
        // _buildZoomButtons()
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Obx(
      () {
        final placeProvider = Get.find<PlaceProvider>();
        return _buildGoogleMapView(placeProvider, placeProvider.mapType);
      },
    );
  }

  Widget _buildPin() {
    return Center(
      child: Obx(() {
        final state = Get.find<PlaceProvider>().pinState;
        if (pinBuilder == null) {
          return _defaultPinBuilder(Get.context!, state);
        } else {
          return Builder(
            builder: (builderContext) => pinBuilder!(builderContext, state),
          );
        }
      }),
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, size: 36, color: Colors.red),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                  child: Icon(Icons.place, size: 36, color: Colors.red),
                ),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildGoogleMapView(PlaceProvider? provider, MapType mapType) {
    CameraPosition initialCameraPosition =
        CameraPosition(target: initialTarget, zoom: 15);
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      zoomGesturesEnabled: zoomGesturesEnabled,
      zoomControlsEnabled: zoomControlsEnabled,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      mapType: mapType,
      myLocationEnabled: true,
      // circles: pickArea != null && pickArea!.radius > 0
      //     ? Set<Circle>.from([pickArea])
      //     : Set<Circle>(),
      markers: markers!,
      onMapCreated: (GoogleMapController controller) {
        if (provider == null) return;
        provider.mapController = controller;
        provider.setCameraPosition(null);
        provider.pinState = PinState.Idle;

        // When select initialPosition set to true.
        if (selectInitialPosition!) {
          provider.setCameraPosition(initialCameraPosition);
          _searchByCameraLocation(provider);
        }

        if (onMapCreated != null) {
          onMapCreated!(controller);
        }
      },
      onCameraIdle: () {
        if (provider == null) return;
        if (provider.isAutoCompleteSearching) {
          provider.isAutoCompleteSearching = false;
          provider.pinState = PinState.Idle;
          provider.placeSearchingState = SearchingState.Idle;
          return;
        }

        // Perform search only if the setting is to true.
        if (usePinPointingSearch!) {
          // Search current camera location only if camera has moved (dragged) before.
          if (provider.pinState == PinState.Dragging) {
            // Cancel previous timer.
            if (provider.debounceTimer?.isActive ?? false) {
              provider.debounceTimer!.cancel();
            }
            provider.debounceTimer =
                Timer(Duration(milliseconds: debounceMilliseconds!), () {
              _searchByCameraLocation(provider);
            });
          }
        }

        provider.pinState = PinState.Idle;

        if (onCameraIdle != null) {
          onCameraIdle!(provider);
        }
      },
      onCameraMoveStarted: () {
        if (provider == null) return;
        if (onCameraMoveStarted != null) {
          onCameraMoveStarted!(provider);
        }

        provider.setPrevCameraPosition(provider.cameraPosition);

        // Cancel any other timer.
        provider.debounceTimer?.cancel();

        // Update state, dismiss keyboard and clear text.
        provider.pinState = PinState.Dragging;

        // Begins the search state if the hide details is enabled
        if (hidePlaceDetailsWhenDraggingPin!) {
          provider.placeSearchingState = SearchingState.Searching;
        }

        onMoveStart!();
      },
      onCameraMove: (CameraPosition position) {
        if (provider == null) return;
        provider.setCameraPosition(position);
        if (onCameraMove != null) {
          onCameraMove!(position);
        }
      },
      // gestureRecognizers make it possible to navigate the map when it's a
      // child in a scroll view e.g ListView, SingleChildScrollView...
      // ignore: prefer_collection_literals
      gestureRecognizers: Set()
        ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
    );
  }

  _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    if (forceSearchOnZoomChanged == false &&
        provider.prevCameraPosition != null &&
        provider.prevCameraPosition!.target.latitude ==
            provider.cameraPosition!.target.latitude &&
        provider.prevCameraPosition!.target.longitude ==
            provider.cameraPosition!.target.longitude) {
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    provider.placeSearchingState = SearchingState.Searching;

    final GeocodingResponse response =
        await provider.geocoding.searchByLocation(
      Location(
          lat: provider.cameraPosition!.target.latitude,
          lng: provider.cameraPosition!.target.longitude),
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      logger.d("Camera Location Search Error: ${response.errorMessage!}");
      if (onGeocodingSearchFailed != null) {
        onGeocodingSearchFailed!(response.status);
      }
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    if (usePlaceDetailSearch!) {
      final PlacesDetailsResponse detailResponse =
          await provider.places.getDetailsByPlaceId(
        response.results[0].placeId,
      );

      if (detailResponse.errorMessage?.isNotEmpty == true ||
          detailResponse.status == "REQUEST_DENIED") {
        logger.d(
            "Fetching details by placeId Error: ${detailResponse.errorMessage!}");
        if (onGeocodingSearchFailed != null) {
          onGeocodingSearchFailed!(detailResponse.status);
        }
        provider.placeSearchingState = SearchingState.Idle;
        return;
      }

      provider.selectedPlace =
          PickResult.fromPlaceDetailResult(detailResponse.result);
      logger.i("busca desde el lugar seleccionado en la barra!");
    } else {
      provider.selectedPlace =
          PickResult.fromGeocodingResult(response.results[0]);
      logger.i("busca desde la camara!");
    }

    provider.placeSearchingState = SearchingState.Idle;
  }

  Widget _buildMapIcons(BuildContext context) {
    if (appBarKey.currentContext == null) {
      return Container();
    }
    final RenderBox appBarRenderBox =
        appBarKey.currentContext!.findRenderObject() as RenderBox;
    return Positioned(
      top: appBarRenderBox.size.height,
      right: 15,
      child: Column(
        children: <Widget>[
          enableMapTypeButton!
              ? SizedBox(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 4.0,
                    onPressed: onToggleMapType,
                    child: const Icon(Icons.layers),
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
          enableMyLocationButton!
              ? SizedBox(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 4.0,
                    onPressed: onMyLocation,
                    child: const Icon(Icons.my_location),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 48,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _defaultPlaceWidgetBuilder(
      BuildContext context, PickResult? data, SearchingState state) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.1,
      leftPosition: MediaQuery.of(context).size.width * 0.15,
      rightPosition: MediaQuery.of(context).size.width * 0.15,
      width: MediaQuery.of(context).size.width * 0.7,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.Searching
          ? _buildLoadingIndicator()
          : _buildSelectionDetails(context, data!),
    );
  }

  Widget _buildFloatingCard() {
    return Obx(
      () {
        final placeProvider = Get.find<PlaceProvider>();
        final data = Tuple4(
            placeProvider.selectedPlace,
            placeProvider.placeSearchingState,
            placeProvider.isSearchBarFocused,
            placeProvider.pinState);

        if ((data.item1 == null && data.item2 == SearchingState.Idle) ||
            data.item3 == true ||
            data.item4 == PinState.Dragging &&
                hidePlaceDetailsWhenDraggingPin!) {
          return Container();
        } else {
          if (selectedPlaceWidgetBuilder == null) {
            return _defaultPlaceWidgetBuilder(
                Get.context!, data.item1, data.item2);
          } else {
            return Builder(
              builder: (builderContext) => selectedPlaceWidgetBuilder!(
                builderContext,
                data.item1,
                data.item2,
                data.item3,
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result) {
    bool canBePicked = pickArea == null ||
        pickArea!.radius <= 0 ||
        Geolocator.distanceBetween(
                pickArea!.center.latitude,
                pickArea!.center.longitude,
                result.geometry!.location.lat,
                result.geometry!.location.lng) <=
            pickArea!.radius;
    MaterialStateColor buttonColor = MaterialStateColor.resolveWith(
        (states) => canBePicked ? Colors.lightGreen : Colors.red);
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            result.formattedAddress!,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          (canBePicked && (selectText?.isEmpty ?? true)) ||
                  (!canBePicked && (outsideOfPickAreaText?.isEmpty ?? true))
              ? SizedBox.fromSize(
                  size: const Size(56, 56), // button width and height
                  child: ClipOval(
                    child: Material(
                      child: InkWell(
                          overlayColor: buttonColor,
                          onTap: () {
                            if (canBePicked) {
                              onPlacePicked!(result);
                            }
                          },
                          child: Icon(
                              canBePicked
                                  ? Icons.check_sharp
                                  : Icons.app_blocking_sharp,
                              color: buttonColor)),
                    ),
                  ),
                )
              : SizedBox.fromSize(
                  size: Size(MediaQuery.of(context).size.width * 0.8,
                      56), // button width and height
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Material(
                      child: InkWell(
                          overlayColor: buttonColor,
                          onTap: () {
                            if (canBePicked) {
                              onPlacePicked!(result);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  canBePicked
                                      ? Icons.check_sharp
                                      : Icons.app_blocking_sharp,
                                  color: buttonColor),
                              SizedBox.fromSize(size: const Size(10, 0)),
                              Text(
                                  canBePicked
                                      ? selectText!
                                      : outsideOfPickAreaText!,
                                  style: TextStyle(color: buttonColor))
                            ],
                          )),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
