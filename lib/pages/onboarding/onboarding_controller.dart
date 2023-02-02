import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingController extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool? _onboardingComplete;

  bool get isOnbonardingComplete => _onboardingComplete ??= false;

  Future<void> checkOnBoardingProcess() async {
    final SharedPreferences prefs = await _prefs;
    final bool? is_onboarding_complete = prefs.getBool("onboarding_process");
    _onboardingComplete = is_onboarding_complete;
    print("status onboarding: $is_onboarding_complete");
    notifyListeners();
  }

  Future<void> setOnBoardingProcess() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("onboarding_process", true);

    // TODO: remove me
    print(prefs.getBool("onboarding_process"));
    notifyListeners();
  }

  Future<bool> onboardingComplete() async {
    final SharedPreferences prefs = await _prefs;
    final bool is_onboarding_complete =
        prefs.getBool("onboarding_process") ?? false;
    print("onboardingComplete: $is_onboarding_complete");
    return is_onboarding_complete;
  }
}
