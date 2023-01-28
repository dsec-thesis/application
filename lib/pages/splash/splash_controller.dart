import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parking_app/routes/routes.dart';

class SplashController extends ChangeNotifier {
  final Permission _locationPermission;
  String? _routeName;

  String? get routeName => _routeName;

  SplashController(this._locationPermission);

  void checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    _routeName = isGranted ? Routes.HOME : Routes.PERMISSION;
    notifyListeners();
  }
}
