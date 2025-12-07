class Order {
  final int? id;
  final String? reference;
  final DateTime? dateCommande;
  final String? status; // PENDING, CONFIRMED, IN_PROGRESS, DELIVERED, CANCELLED
  final double? montantTotal;
  final int? entrepotId;
  final String? entrepotName;
  final int? clientId;
  final String? clientName;
  final String? clientPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem>? items;

  Order({
    this.id,
    this.reference,
    this.dateCommande,
    this.status,
    this.montantTotal,
    this.entrepotId,
    this.entrepotName,
    this.clientId,
    this.clientName,
    this.clientPhone,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      reference: json['reference'] as String?,
      dateCommande: json['dateCommande'] != null
          ? DateTime.parse(json['dateCommande'] as String)
          : null,
      status: json['status'] as String?,
      montantTotal: (json['montantTotal'] as num?)?.toDouble(),
      entrepotId: json['entrepotId'] as int?,
      entrepotName: json['entrepotName'] as String?,
      clientId: json['clientId'] as int?,
      clientName: json['clientName'] as String?,
      clientPhone: json['clientPhone'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'dateCommande': dateCommande?.toIso8601String(),
      'status': status,
      'montantTotal': montantTotal,
      'entrepotId': entrepotId,
      'clientId': clientId,
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int? id;
  final int? productId;
  final String? productName;
  final int quantity;
  final double? prixUnitaire;
  final double? montantTotal;

  OrderItem({
    this.id,
    this.productId,
    this.productName,
    required this.quantity,
    this.prixUnitaire,
    this.montantTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int?,
      productId: json['productId'] as int?,
      productName: json['productName'] as String?,
      quantity: json['quantity'] as int? ?? 0,
      prixUnitaire: (json['prixUnitaire'] as num?)?.toDouble(),
      montantTotal: (json['montantTotal'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'prixUnitaire': prixUnitaire,
    };
  }
}

