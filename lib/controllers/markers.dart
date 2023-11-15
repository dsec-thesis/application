import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking_app/controllers/parking_controller.dart';
import 'package:smart_parking_app/utils/tools.dart';

import '../pages/reservation/screen_booking_details.dart';


class MarkersProvider extends GetxController {
  final BuildContext context;
  final ParkingController _parkingController = Get.put(ParkingController());

  MarkersProvider(
    this.context,
  );

  static MarkersProvider get to => Get.find();

  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  late List<Map<String, dynamic>> nearestParkings;

  Future<List<Map<String, dynamic>>> getAvailableParkings(
      {required CameraPosition desiredLocation}) async {
    logger.i(
        "Make request to find availables parking slot for position $desiredLocation");
    List<Map<String, dynamic>> results = await _parkingController
        .getNearestParkingsByLocation(position: desiredLocation);

    logger.i("Available parking lot: $results");
    return results;
  }

  Future<void> updateMarkers(CameraPosition? desiredLocation) async {
    final availableParkings =
        await getAvailableParkings(desiredLocation: desiredLocation!);

    final newMarkers = <MarkerId, Marker>{};

    logger.i("Updating markers in the map!");

    for (final parking in availableParkings) {
      final markerId = MarkerId(parking['parkinglot_id']);
      final LatLng latLng =
          LatLng(parking["coordinates"]["lat"], parking["coordinates"]["lng"]);
      final marker = Marker(
        markerId: markerId,
        position: latLng,
        infoWindow: InfoWindow(
          title: parking['name'],
          snippet: 'Direccion: ${parking['street']}',
          onTap: () {
            Get.to(
              () => BookParkingDetailsWidget(
                title: "Detalle",
                parkingName: parking['name'],
                parkinglotId: parking['parkinglot_id'],
                description: parking['street'],
              ),
            );

            logger.i("infossssss");
          },
        ),
      );
      newMarkers.putIfAbsent(markerId, () => marker);
    }

    _markers.clear();
    _markers.addAll(newMarkers);
    logger.i("Markers $_markers");
    update();
  }
}
