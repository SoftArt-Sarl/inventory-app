import 'package:flutter_application_1/models.dart/invoiceModel.dart';

class Sale {
  String id;
  String sellerId;
  String custumerName;
  String custumerAddress;
  double totalAmount;
  double discount;
  DateTime createdAt;
  List<Item> items;

  Sale({
    required this.id,
    required this.sellerId,
    required this.custumerName,
    required this.custumerAddress,
    required this.totalAmount,
    required this.discount,
    required this.createdAt,
    required this.items,
  });

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      sellerId: map['sellerId'],
      custumerName: map['custumerName'],
      custumerAddress: map['custumerAddress'],
      totalAmount: map['totalAmount'].toDouble(),
      discount: map['discount'].toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      items: List<Item>.from(map['items'].map((item) => Item.fromMap(item))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerId': sellerId,
      'custumerName': custumerName,
      'custumerAddress': custumerAddress,
      'totalAmount': totalAmount,
      'discount': discount,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}