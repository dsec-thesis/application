import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parking_app/controllers/auth_controller.dart';
import 'package:smart_parking_app/pages/onboarding/onboarding_controller.dart';
import 'package:smart_parking_app/routes/routes.dart';

import '../../utils/tools.dart';

class SplashController extends ChangeNotifier {
  final Permission _locationPermission;
  final _preferences = OnBoardingController();
  //final AuthController _login = Get.put(AuthController());
  final AppUserController _login = Get.put(AppUserController());
  String? _routeName;

  String? get routeName => _routeName;

  SplashController(this._locationPermission);

  void checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    final isOnboardingComplete = await _preferences.onboardingComplete();
    final isLoginIn = _login.isSignedIn.value;

    if (!isGranted) {
      logger.d("rutas a permisos");
      _routeName = Routes.PERMISSION;
    } else if (!isOnboardingComplete) {
      logger.d("rutas a onboarding: $isOnboardingComplete");
      _routeName = Routes.ONBOARDING;
    } else if (!isLoginIn) {
      logger.d("necesita logearse");
      _routeName = Routes.LOGIN;
    } else {
      logger.d("rutas a home");
      _routeName = Routes.HOME;
    }
    notifyListeners();
  }
}
