import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_parking_app/pages/home/home_page.dart';
import 'package:smart_parking_app/pages/login/auth_controller.dart';
import 'package:smart_parking_app/pages/login/login_page.dart';
import 'package:smart_parking_app/routes/pages.dart';
import 'package:smart_parking_app/routes/routes.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  if (kDebugMode) {
    print("activating wakelock in debug");
    Wakelock.enable();
  }
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    LoginPage(),
    BookedPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            /*
            Positioned(
              right: 20,
              top: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: null,
                    mini: true,
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      // handle search functionality
                    },
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    heroTag: null,
                    mini: true,
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: const Icon(
                      Icons.notifications,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      // handle search functionality
                    },
                  )
                ],
              ),
            ),
            */
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Saves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Booked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
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
  final AuthController _authController = Get.find();

  BookedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: GestureDetector(
          onTap: () async {
            await _authController.google_signout();
            if (_authController.loggedIn) {
              print("inicio exitoso");
              Get.offAll(() => LoginPage());
            } else {
              print("inicio fallido");
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
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Page'),
    );
  }
}
