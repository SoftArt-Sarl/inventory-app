import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:get/get.dart';

class Sellercontroller extends GetxController {
  static Sellercontroller instance = Get.find();
  final RxList<Item> itemsList = <Item>[].obs;

  // Ajouter des articles au panier
  void addToCar(List<String> names) {
    itemsList.value = apiController.items.where((item) => names.contains(item.name)).map((item) {
      item.quantity = 1; // Initialiser la quantité à 1
      return item;
    }).toList();
  }

  // Calcul du sous-total
  double get subtotal => itemsList.fold(
      0.0, (sum, item) => sum + ((item.unitPrice ?? 0) * (item.quantity ?? 0)));

  // Gestion de la remise (si applicable)
  String? discount;

  // Calcul du total
  double get total => subtotal;

  // Nombre total d'articles
  int get totalItems => itemsList.fold(0, (sum, item) => sum + (item.quantity ?? 0));
}
