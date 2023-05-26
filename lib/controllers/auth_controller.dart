import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_app/utils/tools.dart';
import 'package:http/http.dart' as http;

import 'amplifyconfiguration.dart';

class AppUserController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  RxBool isSignedIn = false.obs;
  RxString username = ''.obs;
  final _apiUrl = 'vmfj4o7v3m.execute-api.us-east-1.amazonaws.com';

  AppUserController() {
    bool amplifyConfigured = Amplify.isConfigured;
    logger.i(("Amplify esta configurado? $amplifyConfigured"));
    if (!amplifyConfigured) {
      configureAmplify();
    }
  }

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await _prefs;
    logger.i("se llamada de aca primerO?");
    isSignedIn.value = prefs.getBool('loggedIn') ?? false;
    super.onInit();
  }

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    final SharedPreferences prefs = await _prefs;
    if (!result.isSignedIn) {
      logger
          .e("No se encuentra logeado, por lo que no se debe llamar al metodo");
      await prefs.setBool('loggedIn', false);
    }
    await prefs.setBool('loggedIn', true);

    return result.isSignedIn;
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
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

  void signIn(AuthProvider authProvider) async {
    try {
      await Amplify.Auth.signInWithWebUI(provider: authProvider);
      isSignedIn.value = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleLoginLogout() async {
    await Amplify.Auth.signOut();
    await socialSignIn();
  }

  Future<void> socialSignIn() async {
    final SharedPreferences prefs = await _prefs;

    try {
      final result = await Amplify.Auth.signInWithWebUI();

      if (result is CognitoSignInResult) {
        logger.i('Sign in completed successfully');
        await prefs.setBool("loggedIn", true);
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
      await prefs.setBool('loggedIn', false);
      isSignedIn.value = false;
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      isSignedIn.value = false;
    } on AuthException catch (e) {
      logger.i(e.message);
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

  Future<String> fetchCognitoAuthSession() async {
    try {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final result = await cognitoPlugin.fetchAuthSession();
      return result.userPoolTokensResult.value.accessToken.toJson();
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
      return "error";
    }
  }
}
