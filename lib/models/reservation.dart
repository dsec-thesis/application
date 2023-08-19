// ignore_for_file: non_constant_identifier_names

import 'parkings.dart';

class Reservation {
  final String id;
  final String driver_id;
  final String parkinglot_id;
  final String description;
  final String state;
  final double? price;
  final double? duration;
  final double? created_on;
  late final ParkingLots? parkingLotAssociated;

  Reservation({
    required this.id,
    required this.driver_id,
    required this.parkinglot_id,
    required this.description,
    required this.state,
    this.price,
    this.duration,
    this.created_on,
    this.parkingLotAssociated,
  });

  factory Reservation.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> parkingLotJson) {
    final parkingLot = ParkingLots.fromJson(parkingLotJson);

    return Reservation(
        id: json['id'],
        driver_id: json['driver_id'],
        parkinglot_id: json['parkinglot_id'],
        description: json['description'],
        state: json['state'],
        price: json['price'] != null
            ? double.parse(json['price'].toString())
            : 0.0,
        duration: json['duration'] != null
            ? double.parse(json['duration'].toString())
            : null,
        created_on:
            (DateTime.parse(json['created_on'])).millisecondsSinceEpoch / 1000,
        parkingLotAssociated: parkingLot);
  }

  String formatUnixTimeToHumanReadable() {
    String formattedExpiration;
    if (duration != null) {
      // Convert unixtime to milliseconds
      final int milliseconds = (created_on! * 1000).toInt();

      // Convert to DateTime
      final DateTime createdDateTime =
          DateTime.fromMillisecondsSinceEpoch(milliseconds);

      final DateTime expirationDateTime =
          createdDateTime.add(Duration(seconds: duration!.toInt()));

      final bool isSameDay = DateTime.now().day == expirationDateTime.day;
      if (isSameDay) {
        formattedExpiration =
            "Vencimiento: ${expirationDateTime.hour.toString().padLeft(2, '0')}:${expirationDateTime.minute.toString().padLeft(2, '0')}";
      } else {
        formattedExpiration =
            'Vencimiento: ${expirationDateTime.day.toString().padLeft(2, '0')}/${expirationDateTime.month.toString().padLeft(2, '0')}/${expirationDateTime.year.toString().padLeft(4, '0')} '
            '${expirationDateTime.hour.toString().padLeft(2, '0')}:${expirationDateTime.minute.toString().padLeft(2, '0')}:${expirationDateTime.second.toString().padLeft(2, '0')}';
      }
    } else {
      formattedExpiration = "RESERVA LIBRE";
    }

    return formattedExpiration;
  }

  String formatTime() {
    if (duration == null) {
      return "Reserva Libre";
    }

    if (duration! < 60) {
      return "$duration segundos";
    } else if (duration! < 3600) {
      final minutes = duration! ~/ 60;
      return "$minutes minutos";
    } else {
      final hours = duration! ~/ 3600;
      return "$hours horas";
    }
  }

  String getCreationTime() {
    String formattedCreation;
    final int milliseconds = (created_on! * 1000).toInt();

    // Convert to DateTime
    final DateTime createdDateTime =
        DateTime.fromMillisecondsSinceEpoch(milliseconds);

    final bool isSameDay = DateTime.now().day == createdDateTime.day;
    if (isSameDay) {
      formattedCreation =
          "${createdDateTime.hour.toString().padLeft(2, '0')}:${createdDateTime.minute.toString().padLeft(2, '0')}";
    } else {
      formattedCreation =
          '${createdDateTime.day.toString().padLeft(2, '0')}/${createdDateTime.month.toString().padLeft(2, '0')}/${createdDateTime.year.toString().padLeft(4, '0')} '
          '${createdDateTime.hour.toString().padLeft(2, '0')}:${createdDateTime.minute.toString().padLeft(2, '0')}:${createdDateTime.second.toString().padLeft(2, '0')}';
    }

    return formattedCreation;
  }

  String getExpirationTime() {
    String formattedExpiration;

    // Convert unixtime to milliseconds
    final int milliseconds = (created_on! * 1000).toInt();

    // Convert to DateTime
    final DateTime createdDateTime =
        DateTime.fromMillisecondsSinceEpoch(milliseconds);

    final DateTime expirationDateTime =
        createdDateTime.add(Duration(seconds: duration!.toInt()));

    final bool isSameDay = DateTime.now().day == expirationDateTime.day;
    if (isSameDay) {
      formattedExpiration =
          "${expirationDateTime.hour.toString().padLeft(2, '0')}:${expirationDateTime.minute.toString().padLeft(2, '0')}";
    } else {
      formattedExpiration =
          '${expirationDateTime.day.toString().padLeft(2, '0')}/${expirationDateTime.month.toString().padLeft(2, '0')}/${expirationDateTime.year.toString().padLeft(4, '0')} '
          '${expirationDateTime.hour.toString().padLeft(2, '0')}:${expirationDateTime.minute.toString().padLeft(2, '0')}:${expirationDateTime.second.toString().padLeft(2, '0')}';
    }

    return formattedExpiration;
  }
}
