import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking_app/controllers/parking_controller.dart';

class TestApiRequest extends StatelessWidget {
  final ParkingController parkingController = Get.put(ParkingController());
  final CameraPosition target;
  TestApiRequest({super.key, required this.target});

  void testApi() async {
    parkingController.getNearestParkingsByLocation(position: target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Api for Debug'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: testApi,
              child: const Text('Test Api'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
