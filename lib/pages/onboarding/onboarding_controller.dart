import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingController extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool? _onboardingComplete;

  bool get isOnbonardingComplete => _onboardingComplete ??= false;

  Future<void> checkOnBoardingProcess() async {
    final SharedPreferences prefs = await _prefs;
    final bool? isOnboardingComplete = prefs.getBool("onboarding_process");
    _onboardingComplete = isOnboardingComplete;
    notifyListeners();
  }

  Future<void> setOnBoardingProcess() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("onboarding_process", true);

    notifyListeners();
  }

  Future<bool> onboardingComplete() async {
    final SharedPreferences prefs = await _prefs;
    final bool isOnboardingComplete =
        prefs.getBool("onboarding_process") ?? false;
    return isOnboardingComplete;
  }
}
