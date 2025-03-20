import 'package:flutter_application_1/models.dart/saleModel.dart';
import 'package:flutter_application_1/models.dart/selleModel.dart';

class Invoice {
  String id;
  String saleId;
  String sellerId;
  double totalAmount;
  double discount;
  double finalAmount;
  double taxAmount;
  DateTime createdAt;
  Sale sale;
  Seller seller;

  Invoice({
    required this.id,
    required this.saleId,
    required this.sellerId,
    required this.totalAmount,
    required this.discount,
    required this.finalAmount,
    required this.taxAmount,
    required this.createdAt,
    required this.sale,
    required this.seller,
  });

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      saleId: map['saleId'],
      sellerId: map['sellerId'],
      totalAmount: map['totalAmount'].toDouble(),
      discount: map['discount'].toDouble(),
      finalAmount: map['finalAmount'].toDouble(),
      taxAmount: map['taxAmount'].toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      sale: Sale.fromMap(map['sale']),
      seller: Seller.fromMap(map['seller']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'saleId': saleId,
      'sellerId': sellerId,
      'totalAmount': totalAmount,
      'discount': discount,
      'finalAmount': finalAmount,
      'taxAmount': taxAmount,
      'createdAt': createdAt.toIso8601String(),
      'sale': sale.toMap(),
      'seller': seller.toMap(),
    };
  }
}





class Item {
  String id;
  String saleId;
  String itemId;
  int quantity;
  ItemDetail item;

  Item({
    required this.id,
    required this.saleId,
    required this.itemId,
    required this.quantity,
    required this.item,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      saleId: map['saleId'],
      itemId: map['itemId'],
      quantity: map['quantity'],
      item: ItemDetail.fromMap(map['item']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'saleId': saleId,
      'itemId': itemId,
      'quantity': quantity,
      'item': item.toMap(),
    };
  }
}

class ItemDetail {
  String id;
  String name;
  int quantity;
  double unitPrice;
  double itemsTotal;
  DateTime createdAt;
  String createdById;
  DateTime updatedAt;
  String categoryId;

  ItemDetail({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.itemsTotal,
    required this.createdAt,
    required this.createdById,
    required this.updatedAt,
    required this.categoryId,
  });

  factory ItemDetail.fromMap(Map<String, dynamic> map) {
    return ItemDetail(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'].toDouble(),
      itemsTotal: map['itemsTotal'].toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      createdById: map['createdById'],
      updatedAt: DateTime.parse(map['updatedAt']),
      categoryId: map['categoryId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'itemsTotal': itemsTotal,
      'createdAt': createdAt.toIso8601String(),
      'createdById': createdById,
      'updatedAt': updatedAt.toIso8601String(),
      'categoryId': categoryId,
    };
  }
}
