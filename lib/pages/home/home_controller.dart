import 'dart:async';

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

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
  Position? get initialPosition => _initialPosition;

  bool _loading = true;
  bool get loading => _loading;
  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;
  StreamSubscription? _gpsSubscription;

  HomeController() {
    _init();
  }

  Future<void> turnOnGps() => Geolocator.openLocationSettings();

  Future<void> _init() async {
    _gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _loading = false;
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        _gpsEnabled = status == ServiceStatus.enabled;
        print("_gpsEnables $_gpsEnabled");
        await _getInitialPosition();
        notifyListeners();
      },
    );
    await _getInitialPosition();
    //_initLocationUpdate();
    notifyListeners();
  }

  Future<void> _getInitialPosition() async {
    if (_gpsEnabled && _initialPosition == null) {
      _initialPosition = await Geolocator.getCurrentPosition();
      print("posicion inicial: $initialPosition");
    }
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
        print("new position $value");
      },
    );
    _markers[markerId] = marker;
    notifyListeners();
  }

  @override
  void dispose() {
    _gpsSubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}
