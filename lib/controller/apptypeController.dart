import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppTypeController extends GetxController {
  static AppTypeController get instance => Get.find();

  var isDesktop = false.obs;

  void checkScreenType(BuildContext context) {
    isDesktop.value = MediaQuery.of(context).size.width >= 800;
  }
}
