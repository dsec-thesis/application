import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:smart_parking_app/pages/home/home_page.dart';
import 'package:smart_parking_app/routes/pages.dart';
import 'package:smart_parking_app/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.SPLASH,
      debugShowCheckedModeBanner: false,
      //home: MyHomePage(),
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
    const SavesPage(),
    const BookedPage(),
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
  const BookedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Booked Page'),
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
