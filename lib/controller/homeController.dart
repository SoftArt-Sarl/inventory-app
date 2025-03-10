import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}