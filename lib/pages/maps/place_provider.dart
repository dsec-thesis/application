import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:smart_parking_app/pages/maps/pick_result.dart';

// ignore: constant_identifier_names
enum SearchingState { Idle, Searching }

// ignore: constant_identifier_names
enum PinState { Preparing, Idle, Dragging }

class PlaceProvider extends GetxController {
  PlaceProvider(
    String apiKey,
    String? proxyBaseUrl,
    Client? httpClient,
    Map<String, dynamic> apiHeaders,
  ) {
    places = GoogleMapsPlaces(
      apiKey: apiKey,
      baseUrl: proxyBaseUrl,
      httpClient: httpClient,
      apiHeaders: apiHeaders as Map<String, String>?,
    );

    geocoding = GoogleMapsGeocoding(
      apiKey: apiKey,
      baseUrl: proxyBaseUrl,
      httpClient: httpClient,
      apiHeaders: apiHeaders as Map<String, String>?,
    );
  }

  static PlaceProvider get to => Get.find();

  late GoogleMapsPlaces places;
  late GoogleMapsGeocoding geocoding;
  String? sessionToken;
  bool isOnUpdateLocationCooldown = false;
  LocationAccuracy? desiredAccuracy;
  bool isAutoCompleteSearching = false;

  Future<void> updateCurrentLocation(bool forceAndroidLocationManager) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();

    update();
  }

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
  set currentPosition(Position? newPosition) {
    _currentPosition = newPosition;
    update();
  }

  Timer? _debounceTimer;
  Timer? get debounceTimer => _debounceTimer;
  set debounceTimer(Timer? timer) {
    _debounceTimer = timer;
    update();
  }

  CameraPosition? _previousCameraPosition;
  CameraPosition? get prevCameraPosition => _previousCameraPosition;
  setPrevCameraPosition(CameraPosition? prePosition) {
    _previousCameraPosition = prePosition;
  }

  CameraPosition? _currentCameraPosition;
  CameraPosition? get cameraPosition => _currentCameraPosition;
  setCameraPosition(CameraPosition? newPosition) {
    _currentCameraPosition = newPosition;
    update();
  }

  PickResult? _selectedPlace;
  PickResult? get selectedPlace => _selectedPlace;
  set selectedPlace(PickResult? result) {
    _selectedPlace = result;
    update();
  }

  final Rx<SearchingState> _placeSearchingState = SearchingState.Idle.obs;
  SearchingState get placeSearchingState => _placeSearchingState.value;
  set placeSearchingState(SearchingState newState) {
    _placeSearchingState.value = newState;
    update();
  }

  final Rx<GoogleMapController?> _mapController =
      Rx<GoogleMapController?>(null);
  GoogleMapController? get mapController => _mapController.value;
  set mapController(GoogleMapController? controller) {
    _mapController.value = controller;
    update();
  }

  final Rx<PinState> _pinState = PinState.Preparing.obs;
  PinState get pinState => _pinState.value;
  set pinState(PinState newState) {
    _pinState.value = newState;
    update();
  }

  final RxBool _isSearchBarFocused = false.obs;
  bool get isSearchBarFocused => _isSearchBarFocused.value;
  set isSearchBarFocused(bool focused) {
    _isSearchBarFocused.value = focused;
    update();
  }

  final Rx<MapType> _mapType = MapType.normal.obs;
  MapType get mapType => _mapType.value;
  setMapType(MapType mapType, {bool notify = false}) {
    _mapType.value = mapType;
    if (notify) update();
  }

  switchMapType() {
    _mapType.value =
        MapType.values[(_mapType.value.index + 1) % MapType.values.length];
    if (_mapType.value == MapType.none) _mapType.value = MapType.normal;

    update();
  }
}
