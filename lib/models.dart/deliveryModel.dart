enum DeliveryStatus { PENDING, IN_PROGRESS, DELIVERED }

class Sale {
  final String id;
  final String sellerId;
  final String custumerName;
  final String custumerAddress;
  final double totalAmount;
  final double discount;
  final DateTime createdAt;
  final Invoice2 invoice;

  Sale({
    required this.id,
    required this.sellerId,
    required this.custumerName,
    required this.custumerAddress,
    required this.totalAmount,
    required this.discount,
    required this.createdAt,
    required this.invoice,
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
      invoice: Invoice2.fromMap(map['invoice']),
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
      'invoice': invoice.toMap(),
    };
  }
}

class Invoice2 {
  final String id;
  final String saleId;
  final String sellerId;
  final double totalAmount;
  final double discount;
  final double finalAmount;
  final double taxAmount;
  final DateTime createdAt;

  Invoice2({
    required this.id,
    required this.saleId,
    required this.sellerId,
    required this.totalAmount,
    required this.discount,
    required this.finalAmount,
    required this.taxAmount,
    required this.createdAt,
  });

  factory Invoice2.fromMap(Map<String, dynamic> map) {
    return Invoice2(
      id: map['id'],
      saleId: map['saleId'],
      sellerId: map['sellerId'],
      totalAmount: map['totalAmount'].toDouble(),
      discount: map['discount'].toDouble(),
      finalAmount: map['finalAmount'].toDouble(),
      taxAmount: map['taxAmount'].toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
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
    };
  }
}

class Delivery {
  final String id;
  final String saleId;
  final DeliveryStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deliveryMan;
  final String location;
  final Sale sale;

  Delivery({
    required this.id,
    required this.saleId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryMan,
    required this.location,
    required this.sale,
  });

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'],
      saleId: map['saleId'],
      status: _statusFromString(map['status']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      deliveryMan: map['deliveryMan'],
      location: map['location'],
      sale: Sale.fromMap(map['sale']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'saleId': saleId,
      'status': _statusToString(status),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deliveryMan': deliveryMan,
      'location': location,
      'sale': sale.toMap(),
    };
  }

  // Méthode copyWith pour modifier uniquement certaines valeurs
  Delivery copyWith({
    DeliveryStatus? status,
    DateTime? updatedAt,
  }) {
    return Delivery(
      id: id,
      saleId: saleId,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryMan: deliveryMan,
      location: location,
      sale: sale,
    );
  }
Delivery copyWith2({
    String? deliveryMan,
    String? location,
  }) {
    return Delivery(
      id: id,
      saleId: saleId,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deliveryMan: deliveryMan?? this.deliveryMan,
      location: location?? this.location,
      sale: sale,
    );
  }
  // Fonction pour convertir une chaîne en DeliveryStatus
  static DeliveryStatus _statusFromString(String status) {
    switch (status) {
      case 'PENDING':
        return DeliveryStatus.PENDING;
      case 'IN_PROGRESS':
        return DeliveryStatus.IN_PROGRESS;
      case 'DELIVERED':
        return DeliveryStatus.DELIVERED;
      default:
        throw ArgumentError('Invalid status: $status');
    }
  }

  // Fonction pour convertir DeliveryStatus en chaîne
  static String _statusToString(DeliveryStatus status) {
    return status.toString().split('.').last;
  }
}

