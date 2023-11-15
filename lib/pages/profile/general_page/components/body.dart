import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking_app/pages/privacy_policy/privacy_policy.dart';
import 'package:smart_parking_app/pages/privacy_policy/terms_and_conditions.dart';
import 'package:smart_parking_app/pages/profile/jwt_token/jwt_component.dart';
import 'package:smart_parking_app/pages/reservation/confirmation_component.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../routes/routes.dart';
import '../../account_details/account_page.dart';
import '../../faq_page/faq_page.dart';
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
              Get.to(() => const FaqsComponent());
            },
          ),
          ProfileMenu(
            text: "CopyJWT",
            icon: "assets/icons/Log out.svg",
            press: () {
              Get.to(() => const JWTToken());
            },
          ),
          ProfileMenu(
            text: "Politica de privacidad",
            icon: "assets/icons/Log out.svg",
            press: () {
              Get.to(() => const PrivacyPolicyComponent());
            },
          ),
          ProfileMenu(
            text: "Terminos y condiciones",
            icon: "assets/icons/Log out.svg",
            press: () {
              Get.to(() => const TermsAndConditionsComponent());
            },
          ),
          ProfileMenu(
            text: "Desconectarse",
            icon: "assets/icons/Log out.svg",
            press: () {
              ConfirmationDialog(
                      onConfirm: () {
                        _authController.signOutCurrentUser();
                        Get.offAndToNamed(Routes.LOGIN);
                      },
                      title: "Confirmación",
                      question:
                          "¿Esta seguro que quiere desloguearse de la aplicación?")
                  .show(context);
            },
          ),
        ],
      ),
    );
  }
}
