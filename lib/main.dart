import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_parking_app/pages/home/home_page.dart';
import 'package:smart_parking_app/pages/login/login_page.dart';
import 'package:smart_parking_app/routes/pages.dart';
import 'package:smart_parking_app/routes/routes.dart';
import 'package:smart_parking_app/utils/tools.dart';
import 'package:wakelock/wakelock.dart';

import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  if (kDebugMode) {
    print("activating wakelock in debug");
    Wakelock.enable();
  }
  initializateLogger();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.SPLASH,
      debugShowCheckedModeBanner: false,
      routes: appRoutes(),
    );
  }
}

class MainComponent extends StatefulWidget {
  const MainComponent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainComponentState createState() => _MainComponentState();
}

class _MainComponentState extends State<MainComponent> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    LoginPage(),
    BookedPage(),
    ProfilePage(),
  ];

  void setIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.moving),
        onPressed: () {
          logger.i("boton presionado");
        },
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.none,
        notchMargin: 8.0,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Colors.blueGrey : Colors.grey,
                ),
                onPressed: () {
                  setIndex(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.wallet_outlined,
                  color: _currentIndex == 1 ? Colors.blueGrey : Colors.grey,
                ),
                onPressed: () {
                  setIndex(1);
                },
              ),
              const SizedBox(width: 48.0),
              IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: _currentIndex == 2 ? Colors.blueGrey : Colors.grey,
                ),
                onPressed: () {
                  setIndex(2);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: _currentIndex == 3 ? Colors.blueGrey : Colors.grey,
                ),
                onPressed: () {
                  setIndex(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavesPage extends StatelessWidget {
  const SavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Saves Page'),
    );
  }
}

class BookedPage extends StatelessWidget {
  //final AuthController _authController = Get.find();
  final AppUserController _authController = Get.find();

  BookedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: GestureDetector(
          onTap: () async {
            await _authController.signOutCurrentUser();
            if (!_authController.isSignedIn.value) {
              //logger.d("inicio exitoso");
              Get.offAll(() => LoginPage());
            } else {
              logger.d("there was an issue in the logout process");
            }
          },
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/varios/google.png',
                  height: 50,
                ),
                const SizedBox(width: 16),
                Text(
                  'Logout Google',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final AppUserController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _authController.fetchCognitoAuthSession(),
      child: const Text('Test API'),
    );
  }
}
