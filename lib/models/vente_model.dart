import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Vente extends Equatable {
  final int? id;
  final int? entrepotId;
  final String? entrepotName;
  final int? clientId;
  final String? clientName;
  final double? montant;
  final String? status;
  final String? paymentType;
  final String? paymentStatus;
  final DateTime? dateCreation;
  final DateTime? dateVente;
  final List<VenteItem>? items;

  const Vente({
    this.id,
    this.entrepotId,
    this.entrepotName,
    this.clientId,
    this.clientName,
    this.montant,
    this.status,
    this.paymentType,
    this.paymentStatus,
    this.dateCreation,
    this.dateVente,
    this.items,
  });

  String get formattedDate {
    if (dateVente == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(dateVente!);
  }

  String get formattedAmount {
    if (montant == null) return '0 FCFA';
    return '${NumberFormat('#,###').format(montant)} FCFA';
  }

  factory Vente.fromJson(Map<String, dynamic> json) {
    return Vente(
      id: json['id'] as int?,
      entrepotId: json['entrepotId'] as int?,
      entrepotName: json['entrepotName'] as String?,
      clientId: json['clientId'] as int?,
      clientName: json['clientName'] as String?,
      montant: (json['montant'] as num?)?.toDouble(),
      status: json['status'] as String?,
      paymentType: json['paymentType'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'] as String)
          : null,
      dateVente: json['dateVente'] != null
          ? DateTime.parse(json['dateVente'] as String)
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => VenteItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entrepotId': entrepotId,
      'entrepotName': entrepotName,
      'clientId': clientId,
      'clientName': clientName,
      'montant': montant,
      'status': status,
      'paymentType': paymentType,
      'paymentStatus': paymentStatus,
      'dateCreation': dateCreation?.toIso8601String(),
      'dateVente': dateVente?.toIso8601String(),
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        entrepotId,
        clientId,
        montant,
        dateVente,
      ];
}

class VenteItem extends Equatable {
  final int? id;
  final int? productId;
  final String? productName;
  final String? productCode;
  final int? quantity;
  final double? unitPrice;
  final double? totalPrice;

  const VenteItem({
    this.id,
    this.productId,
    this.productName,
    this.productCode,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
  });

  factory VenteItem.fromJson(Map<String, dynamic> json) {
    return VenteItem(
      id: json['id'] as int?,
      productId: json['productId'] as int?,
      productName: json['productName'] as String?,
      productCode: json['productCode'] as String?,
      quantity: json['quantity'] as int?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        quantity,
        unitPrice,
      ];
}

