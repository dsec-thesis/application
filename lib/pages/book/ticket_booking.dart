import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_parking_app/utils/tools.dart';

class TicketParkingDetailsWidget extends StatefulWidget {
  final String bookingId;
  final String description;
  final String parkingName;
  final String parkingStreet;
  final String reservationCreationTime;
  final String reservationExpirationTime;
  final String durationReservationTime;
  final String plate;
  final String parkinglotId;
  final bool isExpired;
  final double price;
  final String userPhone;

  const TicketParkingDetailsWidget({
    super.key,
    required this.description,
    required this.parkingName,
    required this.parkinglotId,
    required this.parkingStreet,
    required this.reservationCreationTime,
    required this.isExpired,
    required this.price,
    required this.plate,
    required this.reservationExpirationTime,
    required this.durationReservationTime,
    required this.bookingId,
    required this.userPhone,
  });
  @override
  // ignore: library_private_types_in_public_api
  _TicketParkingDetailsWidgetState createState() =>
      _TicketParkingDetailsWidgetState();
}

class _TicketParkingDetailsWidgetState
    extends State<TicketParkingDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Parking ticket",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white),
      body: Container(
        width: SizeConfig.screenWidth,
        color: const Color.fromRGBO(238, 238, 238, 1.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: SizeConfig.screenWidth * .9,
                  height: SizeConfig.screenHeight * .62,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: SizeConfig.screenWidth * .8,
                        child: const Text(
                          "Acerque su telefono al scanner cuando se encuentre en el estacionamiento",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * .02,
                      ),
                      QrImageView(
                        data: widget.bookingId,
                        version: QrVersions.auto,
                        size: 150,
                        gapless: false,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Estacionamiento:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .005,
                                  ),
                                  Text(
                                    widget.parkingName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .01,
                                  ),
                                  const Text(
                                    "Direccion:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .005,
                                  ),
                                  Text(
                                    widget.parkingStreet,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .01,
                                  ),
                                  const Text(
                                    "Duracion:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .005,
                                  ),
                                  Text(
                                    widget.durationReservationTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .01,
                                  ),
                                  const Text(
                                    "Fecha finalización:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .005,
                                  ),
                                  Text(
                                    widget.reservationExpirationTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Parking slot:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .005,
                                  ),
                                  FittedBox(
                                    child: SizedBox(
                                      height: SizeConfig.screenHeight * .05,
                                      width: SizeConfig.screenWidth * .5,
                                      child: Text(
                                        widget.parkinglotId,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .01,
                                  ),
                                  const Text(
                                    "Patente:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    widget.plate,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .01,
                                  ),
                                  const Text(
                                    "Fecha reservación",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .005,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.screenWidth * .4,
                                    child: Text(
                                      widget.reservationCreationTime,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .01,
                                  ),
                                  const Text(
                                    "Telefono:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.screenHeight * .005,
                                  ),
                                  Text(
                                    widget.userPhone,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(
                    width: SizeConfig.screenWidth * .9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 211, 99, 1.0)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'VOLVER',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
