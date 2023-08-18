// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking_app/pages/book/parking_card_component.dart';
import 'package:smart_parking_app/pages/reservation/confirmation_component.dart';
import 'package:smart_parking_app/utils/tools.dart';

import '../../controllers/reservation_controller.dart';
import '../reservation/cancel_reservation_animation.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  int _selectedIndex = 0;
  ReservationController reservationController =
      Get.put(ReservationController());

  final List<Widget> _views = [
    OngoingBookingView(),
    BookingHistoryView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Mis Reservas",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  _onItemTapped(0);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: NavBarItem(
                    label: 'Ongoing Booking',
                    isSelected: _selectedIndex == 0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _onItemTapped(1);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: NavBarItem(
                    label: 'Booking History',
                    isSelected: _selectedIndex == 1,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _views[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String label;
  final bool isSelected;

  NavBarItem({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: isSelected ? UnderlinePainter() : null,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class UnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final startPoint = Offset(0, size.height);
    final endPoint = Offset(size.width, size.height);

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class OngoingBookingView extends GetWidget {
  ReservationController reservationController = Get.find();

  OngoingBookingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        logger.i("Actualizando reservas en ongoing booking screen");
        if (reservationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: reservationController.fetchReservations,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: reservationController.reservationsList.length,
              itemBuilder: (context, index) {
                if (reservationController.reservationsList[index].state ==
                    "ACCOMMODATED") {
                  return ParkingCard(
                    parkingTitle: reservationController
                        .reservationsList[index].parkingLotAssociated!.name,
                    parkingStreet: reservationController
                        .reservationsList[index].parkingLotAssociated!.street,
                    reservationTime: reservationController
                        .reservationsList[index]
                        .formatUnixTimeToHumanReadable(),
                    rating: 5,
                    price: reservationController.reservationsList[index].price!,
                    isExpired:
                        reservationController.reservationsList[index].state ==
                                "CANCELED"
                            ? true
                            : false,
                    cancelBooking: () => ConfirmationDialog(
                      title: 'Confirmación',
                      question: '¿Desea cancelar la reserva?',
                      onConfirm: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: SizeConfig.screenWidth * .7,
                                  height: SizeConfig.screenHeight * .5,
                                  child: CancelReservationAnimated(
                                    bookingId: reservationController
                                        .reservationsList[index].id,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ).show(context),
                    viewTicket: () {},
                  );
                }
                return const SizedBox();
              },
            ),
          );
        }
      },
    );
  }
}

class BookingHistoryView extends StatelessWidget {
  BookingHistoryView({super.key});
  ReservationController reservationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        logger.i("Actualizando reservas en history booking screen");
        if (reservationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: reservationController.fetchReservations,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: reservationController.reservationsList.length,
              itemBuilder: (context, index) {
                if (reservationController.reservationsList[index].state ==
                    "CANCELED") {
                  return ParkingCard(
                    parkingTitle: reservationController
                        .reservationsList[index].parkingLotAssociated!.name,
                    parkingStreet: reservationController
                        .reservationsList[index].parkingLotAssociated!.street,
                    reservationTime: reservationController
                        .reservationsList[index]
                        .formatUnixTimeToHumanReadable(),
                    rating: 5,
                    price: reservationController.reservationsList[index].price!,
                    isExpired:
                        reservationController.reservationsList[index].state ==
                                "CANCELED"
                            ? true
                            : false,
                    cancelBooking: () => logger.i("Terminar reservaaaaa"),
                    viewTicket: () {},
                  );
                }
                return const SizedBox();
              },
            ),
          );
        }
      },
    );
  }
}
