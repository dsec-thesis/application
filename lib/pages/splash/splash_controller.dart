import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parking_app/pages/login/auth_controller.dart';
import 'package:smart_parking_app/pages/onboarding/onboarding_controller.dart';
import 'package:smart_parking_app/routes/routes.dart';

class SplashController extends ChangeNotifier {
  final Permission _locationPermission;
  final _preferences = OnBoardingController();
  final AuthController _login = Get.put(AuthController());
  String? _routeName;

  String? get routeName => _routeName;

  SplashController(this._locationPermission);

  void checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    final isOnboardingComplete = await _preferences.onboardingComplete();
    final isLoginIn = _login.loggedIn;

    if (!isGranted) {
      print("rutas a permisos");
      _routeName = Routes.PERMISSION;
    } else if (!isOnboardingComplete) {
      print("rutas a onboarding: $isOnboardingComplete");
      _routeName = Routes.ONBOARDING;
    } else if (!isLoginIn) {
      print("necesita logearse");
      _routeName = Routes.LOGIN;
    } else {
      print("rutas a home");
      _routeName = Routes.HOME;
    }
    notifyListeners();
  }
}
