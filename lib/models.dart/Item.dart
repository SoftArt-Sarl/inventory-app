import 'package:intl/intl.dart';

class Item {
  String? id;
  String? name;
  int? quantity;
  int? unitPrice;
  int? itemsTotal;
  DateTime? createdAt;
  String? createdById;
  DateTime? updatedAt;
  String? categoryId;

  Item({
    this.id,
    this.name,
    this.quantity,
    this.unitPrice,
    this.itemsTotal,
    this.createdAt,
    this.createdById,
    this.updatedAt,
    this.categoryId,
  });
  static int calculateTotalQuantity(List<Item> items) {
    return items.fold(0, (total, item) => total + (item.quantity ?? 0));
  }

  static List<Item> getOutOfStockItems(List<Item> items) {
    return items.where((item) => (item.quantity ?? 0) < 10).toList();
  }

  static int calculateTotalValue(List<Item> items) {
    return items.fold(
        0,
        (total, item) =>
            total + ((item.quantity ?? 0) * (item.unitPrice ?? 0)));
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      itemsTotal: json['itemsTotal'],
      createdAt: DateTime.parse(json['createdAt']),
      createdById: json['createdById'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson1() {
    return {
      'id': id,
      'categoryId': categoryId,
      'Nom': name,
      'quantité': quantity,
      'Prix unitaire': '$unitPrice',
      'Total': '$itemsTotal',
      'Catégorie': categoryId,
      'Status': quantity! <= 10 ? true : false,
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'id': id,
      'categoryId': categoryId,
      'Nom': name,
      'quantité': quantity,
      'Prix unitaire': '$unitPrice',
      'Total': '$itemsTotal',
      // 'Catégorie':,
      'Status': quantity! <= 10 ? true : false,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'itemsTotal': itemsTotal,
      'createdAt': createdAt!.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'categoryId': categoryId,
    };
  }

  Map<String, dynamic> toJson3() {
    return {
      'itemId': id,
      'quantity': quantity,
    };
  }
}
