import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../utils/tools.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: ((context) {
        final controller = HomeController();
        controller.onMarkerTap.listen((String id) {
          logger.d("go to $id");
        });
        return controller;
      }),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Selector<HomeController, bool>(
              selector: (context, controller) => controller.loading,
              builder: (context, loading, child) {
                if (loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Consumer<HomeController>(
                  builder: ((context, controller, gpsMessageWidget) {
                    if (!controller.gpsEnabled) {
                      return gpsMessageWidget!;
                    }

                    final initialPosition = controller.initialCameraPosition;
                    return GoogleMap(
                      markers: controller.markers,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      initialCameraPosition: initialPosition,
                      zoomControlsEnabled: false,
                      onTap: controller.onTap,
                      onLongPress: (position) {
                        logger.d(position);
                      },
                    );
                  }),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                            "Necesitamos acceso al GPS para usar la APP.",
                            textAlign: TextAlign.center),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: (() {
                              final controller = context.read<HomeController>();
                              controller.turnOnGps();
                            }),
                            child: const Text("Encender GPS"))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
