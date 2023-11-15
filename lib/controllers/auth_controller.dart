import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/utils/tools.dart';

import 'amplifyconfiguration.dart';

class AppUserController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  RxBool isSignedIn = false.obs;
  String? _cachedToken;

  AppUserController() {
    checkUserStatus();
  }

  Future<void> configureAmplify() async {
    try {
      logger.i("Configurando amplify");
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      logger.e('An error occurred configuring Amplify: $e');
    }
    logger.i("Amplify configured!");
  }

  Future<bool> getUserStatus() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      logger.i('User is signed in: ${user.signInDetails}');
      return true;
    } on AuthException catch (e) {
      logger.e('Error retrieving auth session: ${e.message}');
      return false;
    }
  }

  Future<AuthUser> getCurrentUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      safePrint('User is signed in: ${user.signInDetails}');
      return user;
    } on AuthException catch (e) {
      logger.i('Error retrieving auth session: ${e.message}');
      throw Exception("ERROR WACHOOOOO");
    }
  }

  Future<void> checkUserStatus() async {
    try {
      logger.i("inside user status function");
      await configureAmplify();
      final user = await Amplify.Auth.getCurrentUser();
      logger.i('User is signed in: ${user.signInDetails}');
      isSignedIn.value = true;
    } on AuthException catch (e) {
      logger.e('Error retrieving auth session: ${e.message}');
      isSignedIn.value = false;
    }
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

  int extractExpirationTime(String token) {
    final tokenParts = token.split('.');
    if (tokenParts.length != 3) {
      return 0;
    }

    try {
      final payload = tokenParts[1];
      final paddedPayload = payload + '=' * (4 - payload.length % 4);
      final decodedPayload = base64Url.decode(paddedPayload);
      final payloadMap = json.decode(utf8.decode(decodedPayload));

      if (payloadMap.containsKey('exp')) {
        return payloadMap['exp'];
      } else {
        return 0;
      }
    } catch (e) {
      logger.e("ISSUE: $e");
      return 0;
    }
  }

  Future<String?> getCognitoAccessToken() async {
    if (_cachedToken != null) {
      final tokenExpirationTime = extractExpirationTime(_cachedToken!);
      final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch / 1000;
      if (tokenExpirationTime > currentTime) {
        return _cachedToken;
      }
    }
    try {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);

      final result = await cognitoPlugin.fetchAuthSession(
        options: const FetchAuthSessionOptions(forceRefresh: true),
      );

      logger.i(
          "Refresh token: ${result.userPoolTokensResult.value.refreshToken}");
      _cachedToken = result.userPoolTokensResult.value.accessToken.toJson();
      return _cachedToken;
    } on AuthException catch (e) {
      logger.e('Error retrieving auth session - getCognitoAccessToken: ${e.message}');
      //await signOutCurrentUser();
    }
    return null;
  }
}
