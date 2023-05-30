import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/utils/tools.dart';
import 'package:http/http.dart' as http;

import 'amplifyconfiguration.dart';

class AppUserController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final RxBool isSignedIn = false.obs;
  final _apiUrl = 'vmfj4o7v3m.execute-api.us-east-1.amazonaws.com';

  AppUserController() {
    bool amplifyConfigured = Amplify.isConfigured;
    logger.i(("Amplify esta configurado? $amplifyConfigured"));
    if (!amplifyConfigured) {
      configureAmplify();
    }
  }

  Future<void> configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      logger.e('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await _prefs;
    isSignedIn.value = prefs.getBool('isSignedIn') ?? false;
    logger.i("valor issignedIn: ${isSignedIn.value}");
    logger.i("shared: ${prefs.getBool('isSignedIn')}");
    super.onInit();
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }

  Future<void> socialSignIn() async {
    try {
      final SharedPreferences prefs = await _prefs;
      final result = await Amplify.Auth.signInWithWebUI();

      if (result is CognitoSignInResult) {
        logger.i('Sign in completed successfully');
        await prefs.setBool('isSignedIn', true);
        isSignedIn.value = true;
      }

      logger.i('Sign in result: $result');
    } on AuthException catch (e) {
      logger.e('Error signing in: ${e.message}');
    }
  }

  Future<void> signOutCurrentUser() async {
    final SharedPreferences prefs = await _prefs;
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      logger.i('Sign out completed successfully');
      await prefs.setBool('isSignedIn', false);
      isSignedIn.value = false;
    } else if (result is CognitoFailedSignOut) {
      logger.e('Error signing user out: ${result.exception.message}');
    }
  }

  Future<void> testAPI(apiUrl, token) async {
    var url = Uri.https(apiUrl);
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$token',
    });
    logger.i(response.body);
  }

  Future<String?> getCognitoAccessToken() async {
    try {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final result = await cognitoPlugin.fetchAuthSession();
      //testAPI(_apiUrl, result.userPoolTokensResult.value.accessToken.raw);
      return result.userPoolTokensResult.value.accessToken.raw;
    } on AuthException catch (e) {
      logger.e('Error retrieving auth session: ${e.message}');
    }
    return null;
  }

  Future<void> fetchAuthSession() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      safePrint('User is signed in: ${user.signInDetails}');
    } on AuthException catch (e) {
      logger.i('Error retrieving auth session: ${e.message}');
    }
  }
}
