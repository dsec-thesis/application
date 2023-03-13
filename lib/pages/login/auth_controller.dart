import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late final GoogleSignIn googleSignIn = GoogleSignIn();

  final RxBool _loggedIn = false.obs;
  RxBool isSignedIn = false.obs;
  bool get loggedIn => _loggedIn.value;

  Future<void> google_signout() async {
    bool isSignedIn = await googleSignIn.isSignedIn();
    final SharedPreferences prefs = await _prefs;

    if (!isSignedIn) {
      print("No se encuentra logeado, por lo que no se debe llamar al metodo");
      await prefs.setBool('loggedIn', false);
    }

    print("Logout en curso");
    final status = await googleSignIn.disconnect();
    print(status);
  }

  Future<void> handleLoginLogout() async {
    final SharedPreferences prefs = await _prefs;
    if (_loggedIn.value) {
      await googleSignIn.signOut();
      await prefs.setBool('loggedIn', false);
      _loggedIn.value = false;
    } else {
      final account = await googleSignIn.signIn();
      if (account != null) {
        await prefs.setBool("loggedIn", true);
        _loggedIn.value = true;
      }
    }
  }

  @override
  Future<void> onInit() async {
    final SharedPreferences prefs = await _prefs;
    _loggedIn.value = prefs.getBool('loggedIn') ?? false;
    super.onInit();
  }
}
