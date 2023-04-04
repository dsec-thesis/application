import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../env/env.dart';
import '../../utils/tools.dart';
import '../maps/maps_controller.dart';
import '../maps/maps_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapsController _mapsController = Get.put(MapsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapsController>(
      init: MapsController(),
      builder: (controller) {
        controller.onMarkerTap.listen((String id) {
          logger.d("go to $id");
        });

        if (controller.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!controller.gpsEnabled) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Necesitamos acceso al GPS para usar la APP.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => controller.turnOnGps(),
                  child: const Text("Encender GPS"),
                )
              ],
            ),
          );
        }

        return MapsPage(
          apiKey: Env.androidGeolotaionkey,
          initialPosition: LatLng(_mapsController.initialPosition!.latitude,
              _mapsController.initialPosition!.longitude),
        );
      },
    );
  }
}
