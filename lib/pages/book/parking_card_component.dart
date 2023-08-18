import 'package:flutter/material.dart';

import '../../utils/tools.dart';

class ParkingCard extends StatelessWidget {
  final String parkingTitle;
  final String parkingStreet;
  final double price;
  final String reservationTime;
  final double rating;
  final bool isExpired;
  final VoidCallback cancelBooking;
  final VoidCallback viewTicket;

  const ParkingCard({
    Key? key,
    required this.parkingTitle,
    required this.rating,
    required this.price,
    required this.cancelBooking,
    required this.parkingStreet,
    required this.reservationTime,
    required this.isExpired,
    required this.viewTicket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(244, 244, 244, 100),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/parking_lot.jpg",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parkingTitle,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          parkingStreet,
                        ),
                        Text(
                          reservationTime,
                        ),
                        Text(
                          'Precio: ${price}',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          buildButtons(isExpired),
        ],
      ),
    );
  }

  Widget buildButtons(bool isExpired) {
    return Container(
      height: SizeConfig.screenHeight * .05,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isExpired)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8)), // Bordes cuadrados
                    ),
                  ),
                  onPressed: cancelBooking,
                  child: const Text(
                    "Cancelar booking",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 211, 99, 1.0),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(
                      255, 211, 99, 1.0), // Color personalizado
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8)), // Bordes cuadrados
                    // Bordes cuadrados
                  ),
                ),
                onPressed: viewTicket,
                child: const Text(
                  "Ver Ticket",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
