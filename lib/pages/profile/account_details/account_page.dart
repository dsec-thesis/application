import 'package:flutter/material.dart';
import 'package:smart_parking_app/pages/profile/general_page/components/profile_pic.dart';

import '../../../utils/tools.dart';
import 'components/complete_profile.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Mi cuenta',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Center(child: ProfilePic()),
                  //const SizedBox(height: 20),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  const CompleteProfileForm(),
                  //SizedBox(height: getProportionateScreenHeight(30)),
                  // Text(
                  //   "By continuing your confirm that you agree \nwith our Term and Condition",
                  //   textAlign: TextAlign.center,
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
