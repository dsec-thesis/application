import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking_app/pages/profile/jwt_token/jwt_component.dart';
import 'package:smart_parking_app/pages/profile/jwt_token/test_booking.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../routes/routes.dart';
import '../../account_details/account_page.dart';
import '../../jwt_token/get_parking_by_location.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  Body({super.key});
  final AppUserController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfilePic(),
          const SizedBox(height: 20),
          ProfileMenu(
            text: "Mi cuenta",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserAccountPage()))
            },
          ),
          ProfileMenu(
            text: "FAQs",
            icon: "assets/icons/Question mark.svg",
            press: () {
              // Get.to(() => const TicketParkingDetailsWidget(
              //       parkingName: 'Parking Name',
              //       parkinglotId: 'LOT ID',
              //       parkingStreet: "direccionnn",
              //       description:
              //           'Acerque su telefono al scanner cuando se encuentre en el estacionamiento',
              //       isExpired: false,
              //       reservationCreationTime: 'TIEMPO DE LA RESERVAAAAAAAA',
              //       reservationExpirationTime: "Tiempo de expiracion",
              //       durationReservationTime: "Tiempo de duracion",
              //       price: 5,
              //       vehicle: 'Toyota',
              //       bookingId: "asdasd",
              //     ));
              // ConfirmationDialog(
              //   title: 'Confirmación',
              //   question: '¿Desea cancelar la reserva?',
              //   onConfirm: () {
              //     // Lógica que se ejecutará cuando se confirme la acción en el diálogo
              //     // Por ejemplo, puedes cancelar la reserva aquí
              //   },
              // ).show(context);
              //Get.to(() => BookParkingDetailsWidget(title: "EJEMPLO", parkingName: "EJEMPLO PARKING NAME",parkinglotId: "12345678", description: "Ejemplo de descripcion"),);
            },
          ),
          ProfileMenu(
            text: "Desconectarse",
            icon: "assets/icons/Log out.svg",
            press: () {
              _authController.signOutCurrentUser();
              Get.offAndToNamed(Routes.LOGIN);
            },
          ),
          // TODO: DELETE THIS AFTER TESTING!!!
          ProfileMenu(
            text: "CopyJWT",
            icon: "assets/icons/Log out.svg",
            press: () {
              Get.to(() => const JWTToken());
            },
          ),
          ProfileMenu(
            text: "Test Get Parking by Location",
            icon: "assets/icons/Log out.svg",
            press: () {
              Get.to(() => TestApiRequest(
                    target: const CameraPosition(
                        target: LatLng(-32.94151359283722, -60.64531177282333)),
                  ));
            },
          ),
          ProfileMenu(
            text: "Test Booking API",
            icon: "assets/icons/Log out.svg",
            press: () {
              Get.to(() => TestBookingApi());
            },
          ),
        ],
      ),
    );
  }
}
