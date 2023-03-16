import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/tools.dart';

class OnBoardingController extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool? _onboardingComplete;

  bool get isOnbonardingComplete => _onboardingComplete ??= false;

  Future<void> checkOnBoardingProcess() async {
    final SharedPreferences prefs = await _prefs;
    final bool? is_onboarding_complete = prefs.getBool("onboarding_process");
    _onboardingComplete = is_onboarding_complete;
    logger.d("status onboarding: $is_onboarding_complete");
    notifyListeners();
  }

  Future<void> setOnBoardingProcess() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("onboarding_process", true);

    // TODO: remove me
    logger.d(prefs.getBool("onboarding_process"));
    notifyListeners();
  }

  Future<bool> onboardingComplete() async {
    final SharedPreferences prefs = await _prefs;
    final bool is_onboarding_complete =
        prefs.getBool("onboarding_process") ?? false;
    logger.d("onboardingComplete: $is_onboarding_complete");
    return is_onboarding_complete;
  }
}
