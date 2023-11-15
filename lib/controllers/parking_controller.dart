import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking_app/utils/network_tool.dart';
import 'package:smart_parking_app/utils/tools.dart';

class ParkingController extends GetxController {
  late dynamic response;
  final ApiHelper apiHelper = ApiHelper();

  Future<List<Map<String, dynamic>>> getNearestParkingsByLocation({
    required CameraPosition position,
    int startDistance = 0,
    int endDistance = 2,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
            "lat": position.target.latitude.toString(),
            "lng": position.target.longitude.toString(),
            "start_distance": startDistance.toString(),
            "end_distance": endDistance.toString(),
            "limit": limit.toString(),
          },
          response = await apiHelper.sendRequest(HttpMethod.GET, "/searcher",
              queryParams: queryParams);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> parkinglots = data['parkinglots'];
        final List<Map<String, dynamic>> parsedParkinglots = parkinglots
            .map((parkinglot) => parkinglot as Map<String, dynamic>)
            .toList();
        return parsedParkinglots;
      } else if (response.statusCode == 401) {
        logger.d("401 Unauthorized!!!");
        Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          "No Autorizado!",
          "Usted no esta autorizado a realizar esta consulta.",
        );
      } else {
        logger.d("ERROR $response");
        throw Exception('Error en la consulta: ${response.statusCode}');
      }
    } catch (e) {
      logger.d(
        "There was an issue trying to get the information of the parking slot $e",
      );
      Get.snackbar(
        "Error :(",
        "Hubo un problema al consultar los estacionamientos disponibles. Vuelva a intentar!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
    return [];
  }
}
