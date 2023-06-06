import 'package:get/get.dart';
import 'package:smart_parking_app/controllers/parking_controller.dart';

import '../controllers/auth_controller.dart';

class GlobalAppServices extends GetxService {
  final AppUserController appUserController = Get.put(AppUserController());
  final ParkingController parkingController = Get.put(ParkingController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    appUserController.onInit();
    parkingController.onInit();
  }
}
