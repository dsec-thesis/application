import 'package:get/get.dart';

class SearchProvider extends GetxController {
  static SearchProvider get to => Get.find();

  String prevSearchTerm = "";
  final RxString _searchTerm = "".obs;
  String get searchTerm => _searchTerm.value;

  set searchTerm(String newValue) {
    _searchTerm.value = newValue;
    update();
  }
}
