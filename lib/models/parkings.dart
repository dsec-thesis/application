import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking_app/utils/tools.dart';

import '../controllers/auth_controller.dart';
import '../env/env.dart';
import 'package:http/http.dart' as http;

class ParkingLots {
  final String id;
  final String name;
  final String street;
  final LatLng coordinates;

  ParkingLots({
    required this.id,
    required this.name,
    required this.street,
    required this.coordinates,
  });

  factory ParkingLots.fromJson(Map<String, dynamic> json) {
    return ParkingLots(
      id: json['id'],
      name: json['name'],
      street: json['street'],
      coordinates:
          LatLng(json['coordinates']["lat"], json['coordinates']["lng"]),
    );
  }

  static Future<ParkingLots> getParkingLotFromId(String parkingLotId) async {
    final AppUserController authController = Get.find();
    String token = "";
    late dynamic response;

    try {
      final uri = Uri.https(
        Env.awsApiGw,
        "/public/parkinglots/$parkingLotId",
      );

      token = (await authController.getCognitoAccessToken())!;
      response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        dynamic parkingLotData = await jsonDecode(response.body);
        return ParkingLots.fromJson(parkingLotData);
      } else if (response.statusCode == 404) {
        logger.e("Parking Lot Not Found");
        throw Exception("Parking Lot Not Found");
      }
    } catch (e) {
      logger.d("ERROR $response");
      throw Exception('Error en la consulta: ${response.statusCode}');
    }
    throw Exception(
        "Ocurrio un error al tratar de obtener la informacion de un parking lot");
  }
}
