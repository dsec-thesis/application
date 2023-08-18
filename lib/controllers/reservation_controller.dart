// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulid/ulid.dart';

import '../models/reservation.dart';
import '../utils/network_tool.dart';
import '../utils/tools.dart';

class ReservationController extends GetxController {
  var isLoading = true.obs;
  late dynamic response;
  RxList<Reservation> reservationsList = <Reservation>[].obs;
  final ApiHelper apiHelper = ApiHelper();

  final Map<String, int> durationMap = {
    '30m': 1800,
    '1h': 3600,
    '3h': 10800,
    '8h': 28800,
    '12h': 43200,
    '24h': 86400,
  };

  @override
  void onInit() {
    fetchReservations();
    super.onInit();
  }

  Future<bool> createReservation(
    String parkingLot,
    String? description,
    String? duration,
  ) async {
    bool success = false;
    try {
      dynamic body;
      String bookingId = Ulid().toString();
      final int selectedDurationInSeconds = durationMap[duration] ?? 0;
      body = jsonEncode({
        'booking_id': bookingId,
        'parkinglot_id': parkingLot,
        'description': description,
        'duration': duration == null ? null : selectedDurationInSeconds,
      });
      final response =
          await apiHelper.sendRequest(HttpMethod.PUT, "/bookings", body: body);

      if (response.statusCode == 204) {
        try {
          final response = await apiHelper.sendRequest(
              HttpMethod.GET, "/bookings/$bookingId");
          if (response.statusCode == 200) {
            final reservationData =
                await json.decode(utf8.decode(response.bodyBytes));
            if (reservationData["state"] == "ACCOMMODATED") {
              success = true;
            }
          } else {
            logger.e(
                "Unable to create the reservation with the booking id: $bookingId");
          }
        } catch (e) {
          logger.e(
              "There was an issue trying to get the status of the reservation in the creation process");
        }
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
        "There was an issue trying to create the reservation: $e",
      );
      Get.snackbar(
        "Error :(",
        "Hubo un error al tratar de crear la reservacion. Vuelva a intentar!",
      );
    } finally {
      Future.microtask(() => fetchReservations());
    }
    return success;
  }

  Future<bool> deleteReservation(String bookingId) async {
    try {
      final response = await apiHelper.sendRequest(
        HttpMethod.DELETE,
        "/bookings/$bookingId",
      );

      if (response.statusCode != 204) {
        logger.e("There was an isuue deleting the booking id: $bookingId");
        return false;
      }
    } catch (e) {
      logger.e("There was an issue in the deleteReservation function: $e");
      throw Exception("Please see the fuction: deleteReservation");
    }

    logger.i("booking id: $bookingId was successfully deleted");
    Future.microtask(fetchReservations);
    return true;
  }

  Future<List<Reservation>> getAllUserReservations() async {
    try {
      final response = await apiHelper.sendRequest(
        HttpMethod.GET,
        "/bookings",
      );

      if (response.statusCode == 200) {
        dynamic reservationsData =
            await json.decode(utf8.decode(response.bodyBytes));
        List<dynamic> rawReservation = reservationsData["bookings"];
        List<Reservation> reservations =
            await Future.wait(rawReservation.map((json) async {
          var parkingLotId = json["parkinglot_id"];
          dynamic parkingLotData =
              await getParkingLotInformationFromId(parkingLotId);

          return Reservation.fromJson(json, parkingLotData);
        }).toList());
        return reservations;
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
        "There was an issue trying to get all the reservations: $e",
      );
      Get.snackbar(
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        "Error :(",
        "Hubo un error al tratar de obtener todas las reservaciones. Vuelva a intentar!",
      );
    }
    throw Exception("Error en la consulta!");
  }

  Future<void> fetchReservations() async {
    isLoading(true);
    try {
      var reservations = await getAllUserReservations();
      reservationsList.clear();
      reservationsList.assignAll(reservations);
      refresh();
    } catch (e) {
      logger.e("There was an issue fetching reservations");
    } finally {
      logger.i("RESERVATION LENGHT: ${reservationsList.length}");
      isLoading(false);
    }
  }

  Future<Reservation> getReservationStatus(String bookingId) async {
    try {
      final response = await apiHelper.sendRequest(
        HttpMethod.GET,
        "/bookings/$bookingId",
      );

      if (response.statusCode == 200) {
        dynamic reservationsData =
            await json.decode(utf8.decode(response.bodyBytes));
        logger.d("reservation data $reservationsData");
        var parkingLotId = reservationsData["parkinglot_id"];
        dynamic parkingLotData =
            await getParkingLotInformationFromId(parkingLotId);
        return Reservation.fromJson(reservationsData, parkingLotData);
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
        "There was an issue trying to get the reservation: $e",
      );
      Get.snackbar(
        "Error :(",
        "Hubo un error al tratar de crear la reservacion. Vuelva a intentar!",
      );
    }
    throw Exception('Error en la consulta por todas las reservaciones');
  }

  Future<Map<String, dynamic>> getParkingLotInformationFromId(
      String parkingLotId) async {
    try {
      final response = await apiHelper.sendRequest(
        HttpMethod.GET,
        "/public/parkinglots/$parkingLotId",
      );

      if (response.statusCode == 200) {
        dynamic parkingLotData =
            await json.decode(utf8.decode(response.bodyBytes));
        return parkingLotData;
      } else if (response.statusCode == 404) {
        logger.e("Parking Lot Not Found");
        throw Exception("Parking Lot Not Found");
      }
    } catch (e) {
      logger.d("ERROR $response");
      throw Exception('Error en la consulta: ${response.statusCode}');
    }
    throw Exception(
      "Ocurrio un error al tratar de obtener la informacion de un parking lot",
    );
  }
}
