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
}