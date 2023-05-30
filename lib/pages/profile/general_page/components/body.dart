import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../routes/routes.dart';
import '../../account_details/account_page.dart';
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
            press: () {},
          ),
          ProfileMenu(
            text: "Desconectarse",
            icon: "assets/icons/Log out.svg",
            press: () {
              _authController.signOutCurrentUser();
              Get.offAndToNamed(Routes.LOGIN);
            },
          ),
        ],
      ),
    );
  }
}
