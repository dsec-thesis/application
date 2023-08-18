import 'package:flutter/material.dart';
import 'package:smart_parking_app/models/reservation.dart';

class TestBookingApi extends StatefulWidget {
  const TestBookingApi({super.key});

  @override
  State<TestBookingApi> createState() => _TestBookingApiState();
}

class _TestBookingApiState extends State<TestBookingApi> {
  String response = "";
  Reservation? reservationData;
  String bookingId = "";
  //String reservations = "";
  List<Reservation> reservations = [];
  Map<String, dynamic>? selectedReservation;
  TextEditingController reservationIdController = TextEditingController();
  String? selectedReservationId;

  // Future<void> createReservation() async {
  //   var serverResponse = await ReservationManager()
  //       .createReservation("5ef7eff6-b786-44e7-a7cb-321bbf0e8611"); //diego

  //   setState(() {
  //     logger.i("Reservation created? $serverResponse");
  //   });
  // }

  Future<void> getReservationStatus(bookingId) async {
    // Reservation reservationStatus =
    //     await ReservationManager().getReservationStatus(bookingId);

    setState(() {
      // reservationData = reservationStatus;
    });
  }

  Future<void> getAllUserReservation() async {
    // final httpresponse = await ReservationManager().getAllUserReservations();
    // logger.i("httpsresponse: $httpresponse");

    // setState(() {
    //   reservations = httpresponse;
    // });
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems() {
    return reservations.map((reservation) {
      return DropdownMenuItem<String>(
        value: reservation.id,
        child: Text(reservation.id),
      );
    }).toList();
  }

  void onChanged(String? value) {
    setState(() {
      selectedReservationId = value!;
      reservationIdController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Booking API for Debug'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ElevatedButton(
            //   onPressed: createReservation,
            //   child: const Text('Create Reservation'),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getAllUserReservation,
              child: const Text('Obtener todas las reservas'),
            ),
            const SizedBox(height: 20),
            Text('Reservaciones del usuario:'),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedReservationId,
              items: buildDropdownMenuItems(),
              onChanged: onChanged,
            ),
            SizedBox(height: 16),
            Text('Ingresar ID de Reservación:'),
            TextField(
              controller: reservationIdController,
            ),
            ElevatedButton(
              onPressed: () {
                String reservationId = reservationIdController.text;
                getReservationStatus(reservationId);
              },
              child: Text('Obtener Datos de Reservación'),
            ),
            SizedBox(height: 16),
            Text('Datos de la Reservación:'),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(reservationData?.id.toString() ?? ""),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
