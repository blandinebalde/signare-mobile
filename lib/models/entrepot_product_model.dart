import 'package:equatable/equatable.dart';
import 'product_model.dart';

class EntrepotProduct extends Equatable {
  final int? id;
  final int? entrepotId;
  final String? entrepotName;
  final Product? product;
  final int? quantity;
  final int? minStock;
  final int? maxStock;
  final double? price;
  final DateTime? lastUpdated;

  const EntrepotProduct({
    this.id,
    this.entrepotId,
    this.entrepotName,
    this.product,
    this.quantity,
    this.minStock,
    this.maxStock,
    this.price,
    this.lastUpdated,
  });

  bool get isLowStock => (quantity ?? 0) <= (minStock ?? 0);
  bool get isOutOfStock => (quantity ?? 0) == 0;

  factory EntrepotProduct.fromJson(Map<String, dynamic> json) {
    return EntrepotProduct(
      id: json['id'] as int?,
      entrepotId: json['entrepotId'] as int?,
      entrepotName: json['entrepotName'] as String?,
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      quantity: json['quantity'] as int?,
      minStock: json['minStock'] as int?,
      maxStock: json['maxStock'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entrepotId': entrepotId,
      'entrepotName': entrepotName,
      'product': product?.toJson(),
      'quantity': quantity,
      'minStock': minStock,
      'maxStock': maxStock,
      'price': price,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        entrepotId,
        product,
        quantity,
      ];
}

