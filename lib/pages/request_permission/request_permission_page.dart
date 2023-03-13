import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parking_app/pages/login/auth_controller.dart';
import 'package:smart_parking_app/pages/login/login_page.dart';
import 'package:smart_parking_app/pages/onboarding/onboarding_controller.dart';
import 'package:smart_parking_app/pages/request_permission/request_permission_controller.dart';

import '../../routes/routes.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({super.key});

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage>
    with WidgetsBindingObserver {
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  final _preferences = OnBoardingController();
  final AuthController _auth = Get.find();
  late StreamSubscription _subscription;
  bool _fromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
        this); // de esta forma escucho cuando cambia el ciclo de vida de la app
    _subscription = _controller.onStatusChanged.listen(
      (status) {
        switch (status) {
          case PermissionStatus.granted:
            if (!_preferences.isOnbonardingComplete) {
              _goToOnboarding();
              break;
            } else if (!_auth.loggedIn) {
              Get.to(LoginPage());
              break;
            }
            /*
            if (_preferences.isOnbonardingComplete && _auth.loggedIn) {
              _goToHome();
              break;
            }
            */
            _goToHome();
            break;
          case PermissionStatus.permanentlyDenied:
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Info"),
                content: const Text(
                    "Los permisos de ubicacion son necesarios para utilizar la app"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        _fromSettings = await openAppSettings();
                      },
                      child: const Text("Go to settings")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar"))
                ],
              ),
            );

            break;
        }
      },
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _fromSettings) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        _goToHome();
      }
    }
    _fromSettings = false;
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }

  void _goToOnboarding() {
    Navigator.pushReplacementNamed(context, Routes.ONBOARDING);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    _preferences.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: ElevatedButton(
              onPressed: (() {
                _controller.request();
              }),
              child: const Text("Allow")),
        ),
      ),
    );
  }
}
