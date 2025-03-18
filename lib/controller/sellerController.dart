import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:get/get.dart';

class Sellercontroller extends GetxController {
  static Sellercontroller instance = Get.find();
  final RxList<Item> itemsList = <Item>[].obs;
  void addTocar(List<String> names) {
    itemsList.value =
        apiController.items.where((item) => names.contains(item.name)).map((item) {
        item.quantity = 1; // Initialiser la quantité à 1
        return item;
      }).toList();
  }
}
