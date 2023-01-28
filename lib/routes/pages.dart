import 'package:flutter/material.dart';
import 'package:smart_parking_app/main.dart';
import 'package:smart_parking_app/pages/request_permission/request_permission_page.dart';
import 'package:smart_parking_app/pages/splash/splash_page.dart';
import 'package:smart_parking_app/routes/routes.dart';

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    Routes.SPLASH: (context) => const SplashPage(),
    Routes.PERMISSION: (context) => const RequestPermissionPage(),
    Routes.HOME: (context) => const MyHomePage()
  };
}
