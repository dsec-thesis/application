import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking_app/pages/home/home_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
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
            Positioned(
              right: 20,
              top: 20,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      mini: true,
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      child: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        // handle search functionality
                      },
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton(
                      mini: true,
                      elevation: 0,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
            ),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: ((context) {
        final controller = HomeController();
        controller.onMarkerTap.listen((String id) {
          print("go to $id");
        });
        return controller;
      }),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Consumer<HomeController>(
              builder: ((context, controller, child) => GoogleMap(
                    markers: controller.markers,
                    initialCameraPosition: controller.initialCameraPosition,
                    zoomControlsEnabled: false,
                    onTap: controller.onTap,
                    onLongPress: (position) {
                      print(position);
                    },
                  )),
            ),
          ),
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
