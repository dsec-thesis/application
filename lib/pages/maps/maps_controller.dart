import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/tools.dart';

class MapsController extends GetxController {
  final Map<MarkerId, Marker> _markers = {};
  LatLng? _lastCameraPosition;
  late final GoogleMapController _googleMapController;

  Set<Marker> get markers => _markers.values.toSet();
  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  Position? _initialPosition;
  CameraPosition get initialCameraPosition => CameraPosition(
        target: LatLng(
          _initialPosition!.latitude,
          _initialPosition!.longitude,
        ),
        zoom: 16,
      );

  LatLng? get lastCameraPosition => _lastCameraPosition;

  GoogleMapController get googleMapController => _googleMapController;

  Future<void> updateCurrentPosition(CameraPosition? newPosition) async {
    _lastCameraPosition = newPosition!.target;
  }

  Position? get initialPosition => _initialPosition;

  final RxBool _loading = true.obs;
  bool get loading => _loading.value;
  final RxBool _gpsEnabled = false.obs;
  bool get gpsEnabled => _gpsEnabled.value;
  StreamSubscription? _gpsSubscription;

  @override
  void onInit() async {
    super.onInit();
    await _init();
  }

  Future<void> turnOnGps() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> _init() async {
    _gpsEnabled.value = await Geolocator.isLocationServiceEnabled();
    _loading.value = false;
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        _gpsEnabled.value = status == ServiceStatus.enabled;
        logger.d("_gpsEnabled ${_gpsEnabled.value}");
        await _getInitialPosition();
      },
    );
    await _getInitialPosition();
  }

  Future<void> _getInitialPosition() async {
    if (_gpsEnabled.value && _initialPosition == null) {
      _initialPosition = await Geolocator.getCurrentPosition();
      _lastCameraPosition =
          LatLng(_initialPosition!.latitude, _initialPosition!.longitude);
      logger.d("initialPosition: $initialPosition");
    }
    update();
  }

  void onTap(LatLng position) {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);
    final marker = Marker(
      markerId: markerId,
      position: position,
      onTap: () {
        _markersController.sink.add(id);
      },
      draggable: true,
      onDragEnd: (value) {
        logger.d("new position $value");
      },
    );
    logger.d("Position: $position");
    _markers[markerId] = marker;
    update();
  }

  @override
  void onClose() {
    _gpsSubscription?.cancel();
    _markersController.close();
    super.onClose();
  }
}
