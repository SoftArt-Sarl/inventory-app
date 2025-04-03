import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/Item.dart';
import 'package:get/get.dart';

class Sellercontroller extends GetxController {
  static Sellercontroller instance = Get.find();
  final RxList<Item> itemsList = <Item>[].obs;
  final RxDouble discount = 0.0.obs; // Remise par défaut à 0.0

  // Ajouter des articles au panier
  void addToCar(BuildContext context, List<String> ids) {
  List<Item> selectedItems = apiController.items
      .where((item) => ids.contains(item.id))
      .toList();

  // Vérification des stocks
  List<String> outOfStockItems = selectedItems
      .where((item) => item.quantity == 0)
      .map((item) => item.name ?? "Unknown")
      .toList();

  // Si des articles sont en rupture de stock, afficher un message
  if (outOfStockItems.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Out of stock: ${outOfStockItems.join(', ')}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red, // Arrière-plan rouge
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Mise à jour de la liste avec uniquement les articles disponibles
  itemsList.value = selectedItems
      .where((item) => item.quantity! > 0) // Vérifie la quantité disponible
      .map((item) => Item(
            id: item.id,
            name: item.name,
            unitPrice: item.unitPrice,
            quantity: 1, // Initialisé à 1 pour le panier
          ))
      .toList();
}


void addItemToCar(String name, BuildContext context) {
  final item = apiController.items.firstWhere((element) => element.name == name);

  if (item.quantity! > 0) {
    // Vérifier si l'élément est déjà dans le panier
    bool alreadyInCart = itemsList.any((cartItem) => cartItem.id == item.id);

    if (!alreadyInCart) {
      final newItem = Item(
        id: item.id,
        name: item.name,
        unitPrice: item.unitPrice,
        quantity: 1, // Toujours initialisé à 1
      );

      itemsList.add(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green, // 🟢 Succès en vert
          duration: const Duration(seconds: 1),
          content: Text(
            '$name added to cart',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 1),
          content: Text(
            '$name is already in the cart!',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
        content: Text(
          '$name is out of stock!',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


  // Calcul du sous-total
  double get subtotal => itemsList.fold(
      0.0, (sum, item) => sum + ((item.unitPrice ?? 0) * (item.quantity ?? 0)));

  // Calcul du total (sous-total - remise)
  double get total => (subtotal - discount.value).clamp(0.0, double.infinity);

  // Nombre total d'articles
  int get totalItems =>
      itemsList.fold(0, (sum, item) => sum + (item.quantity ?? 0));

  // Mettre à jour la remise
  void setDiscount(double value) {
    discount.value = value < 0 ? 0.0 : value; // Empêcher les remises négatives
  }
}
