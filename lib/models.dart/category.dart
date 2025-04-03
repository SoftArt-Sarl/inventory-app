import 'package:flutter_application_1/models.dart/Item.dart';

class Category {
  String? id;
  String? title;
  String? createdById;
  int? total;
  DateTime? updatedAt;
  List<Item>? items;

  Category({
    this.id,
    this.title,
    this.createdById,
    this.updatedAt,
    this.total,
    this.items,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    print("Parsing Category: $json"); // Debug

    return Category(
      id: json['id'],
      title: json['title'],
      total: json['total'],
      createdById: json['createdById'],
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      items: (json['items'] != null && json['items'] is List)
          ? (json['items'] as List)
              .whereType<Map<String, dynamic>>() // Assure que chaque élément est bien un Map
              .map((item) => Item.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdById': createdById,
      'updatedAt': updatedAt?.toIso8601String(),
      'items': items!.map((item) => item.toJson()).toList(),
    };
  }

  Map<String, dynamic> toJson1() {
    int ruptureStock = items!.where((item) => item.quantity! <= 10).length;

    return {
      'Nom': title,
      'Quantité': items!.length ,
      'Prix total (FCFA)': total??0,
      'Rupture de stock': ruptureStock,
    };
  }
}
