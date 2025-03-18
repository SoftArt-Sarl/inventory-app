import 'package:dio/dio.dart';

class Sale {
  final String id;
  final String sellerId;
  final String customerName;
  final String location;
  final List<SaleItem> items;
  final int totalAmount;
  final int discount;
  final String date;

  Sale({
    required this.id,
    required this.sellerId,
    required this.customerName,
    required this.location,
    required this.items,
    required this.totalAmount,
    required this.discount,
    required this.date,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['_id'],
      sellerId: json['sellerId'],
      customerName: json['customer']['name'],
      location: json['customer']['location'],
      items: (json['items'] as List)
          .map((item) => SaleItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
      discount: json['discount'],
      date: json['date'],
    );
  }
}

class SaleItem {
  final String itemId;
  final String name;
  final int quantity;
  final int price;
  final int availableQuantity;

  SaleItem({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.availableQuantity,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      itemId: json['itemId'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      availableQuantity: json['availableQuantity'],
    );
  }
}

