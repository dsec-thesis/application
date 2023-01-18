import 'dart:async';

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

  Set<Marker> get markers => _markers.values.toSet();
  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  final initialCameraPosition = const CameraPosition(
    target: LatLng(-32.9433402, -60.6443232),
    zoom: 16,
  );

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
    _markersController.close();
    super.dispose();
  }
}
