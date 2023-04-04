import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking_app/utils/tools.dart';

class MarkersProvider extends GetxController {
  final String _apiKey;

  MarkersProvider(
    this._apiKey,
  );

  static MarkersProvider get to => Get.find();

  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  late List<Map<String, dynamic>> nearestParkings;

  Future<List<Map<String, dynamic>>> getNearestParkings(
      CameraPosition desiredLocation) async {
    logger.e("get_nearest_parkings");
    const String type = 'parking';
    const double maxDistance = 500;
    logger.d(maxDistance);
    final String location =
        '${desiredLocation.target.latitude},${desiredLocation.target.longitude}';

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=$_apiKey&location=$location&radius=$maxDistance&type=$type';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    final List<dynamic> results = data['results'];
    final List<Map<String, dynamic>> estacionamientos = [];

    for (final result in results) {
      final name = result['name'];
      final lat = result['geometry']['location']['lat'];
      final lng = result['geometry']['location']['lng'];
      final LatLng latLng = LatLng(lat, lng);
      final int plazasTotales = Random().nextInt(5) + 1;
      final int plazasOcupadas = Random().nextInt(5);
      final int plazasLibres = plazasTotales - plazasOcupadas;
      if (plazasLibres > 0) {
        final estacionamiento = {
          'direccion': latLng,
          'nombre': name,
          'plazas_totales': plazasTotales,
          'plazas_ocupadas': plazasOcupadas
        };
        estacionamientos.add(estacionamiento);
      } else {
        logger.d("este estacionamiento no va a entrar");
      }
    }
    logger.i("la cantidad de estacionientos es: ${estacionamientos.length}");
    return estacionamientos;
  }

  Future<void> updateMarkers(CameraPosition? desiredLocation) async {
    final nearestParkings = await getNearestParkings(desiredLocation!);
    final newMarkers = <MarkerId, Marker>{};

    logger.e("entrando a actualizar marcadores");

    for (final parking in nearestParkings) {
      final markerId = MarkerId(parking['nombre']);
      final marker = Marker(
        markerId: markerId,
        position: parking['direccion'],
        infoWindow: InfoWindow(
          title: parking['nombre'],
          snippet:
              'Disponibilidad: ${parking['plazas_ocupadas']}/${parking['plazas_totales']}',
        ),
      );
      newMarkers.putIfAbsent(markerId, () => marker);
    }

    _markers.clear();
    _markers.addAll(newMarkers);
    update();
  }
}
