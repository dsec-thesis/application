import 'package:flutter/material.dart';
import 'package:smart_parking_app/main.dart';
import 'package:smart_parking_app/pages/login/login_page.dart';
import 'package:smart_parking_app/pages/onboarding/onboarding_page.dart';
import 'package:smart_parking_app/pages/request_permission/request_permission_page.dart';
import 'package:smart_parking_app/pages/splash/splash_page.dart';
import 'package:smart_parking_app/routes/routes.dart';

import '../pages/profile/account_details/account_page.dart';

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    Routes.SPLASH: (context) => const SplashPage(),
    Routes.ONBOARDING: (context) => const OnBoardingScreen(),
    Routes.PERMISSION: (context) => const RequestPermissionPage(),
    Routes.HOME: (context) => const MainComponent(),
    Routes.LOGIN: (context) => LoginPage(),
    Routes.ACCOUNT: (context) => const UserAccountPage(),
  };
}

// https://www.youtube.com/watch?v=SG2WNlQfqyc&ab_channel=MitchKoko