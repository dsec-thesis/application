import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

double degreesToRadians(double degrees) {
  return degrees * math.pi / 180;
}

double distanceBetween(LatLng pos1, LatLng pos2) {
  const earthRadius = 6371000; // radio de la Tierra en metros
  final lat1 = degreesToRadians(pos1.latitude);
  final lon1 = degreesToRadians(pos1.longitude);
  final lat2 = degreesToRadians(pos2.latitude);
  final lon2 = degreesToRadians(pos2.longitude);

  final dLat = lat2 - lat1;
  final dLon = lon2 - lon1;

  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);

  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return earthRadius * c; // distancia en metros
}

double getSearchRadiusFromZoom(CameraPosition cameraPosition) {
  /*
    2 * pi * 6378137 m / 256 px = 156543.03392 m/px
    factor de escala utilizado en el sistema de coordenadas de Google Maps
  */
  final zoom = cameraPosition.zoom;
  final metersPerPixel = 156543.03392 *
      cos(cameraPosition.target.latitude * pi / 180) /
      pow(2, zoom);
  return 156543 / metersPerPixel;
}
