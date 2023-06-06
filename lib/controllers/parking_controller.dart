import 'dart:convert';

import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:smart_parking_app/utils/tools.dart';

import 'auth_controller.dart';

class ParkingController extends GetxController {
  final AppUserController _authController = Get.find();
  String token = "";
  final baseUrl = "vmfj4o7v3m.execute-api.us-east-1.amazonaws.com";
  var response;

  Future<List<Map<String, dynamic>>> getNearestParkingsByLocation({
    required CameraPosition position,
    int startDistance = 0,
    int endDistance = 2,
    int limit = 20,
  }) async {
    try {
      final uri = Uri.https(
        baseUrl,
        "/searcher",
        {
          "lat": position.target.latitude.toString(),
          "lng": position.target.longitude.toString(),
          "start_distance": startDistance.toString(),
          "end_distance": endDistance.toString(),
          "limit": limit.toString(),
        },
      );
      token = (await _authController.getCognitoAccessToken())!;

      response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': token,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d("data $data");
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
      );
    }
    return [];
  }
}
