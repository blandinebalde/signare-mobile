class Income {
  final int? id;
  final double amount;
  final DateTime date;
  final String? description;
  final String? typeFacture; // VENTE, ACHAT
  final String? statusFacture; // EN_ATTENTE, PAYEE, ANNULEE
  final String? numeroFacture;
  final int? clientId;
  final String? clientName;
  final int? entrepotId;
  final String? entrepotName;
  final int? orderId;
  final String? orderReference;
  final bool? isPaid;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Income({
    this.id,
    required this.amount,
    required this.date,
    this.description,
    this.typeFacture,
    this.statusFacture,
    this.numeroFacture,
    this.clientId,
    this.clientName,
    this.entrepotId,
    this.entrepotName,
    this.orderId,
    this.orderReference,
    this.isPaid,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'] as int?,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      typeFacture: json['typeFacture'] as String?,
      statusFacture: json['statusFacture'] as String?,
      numeroFacture: json['numeroFacture'] as String?,
      clientId: json['clientId'] as int?,
      clientName: json['clientName'] as String?,
      entrepotId: json['entrepotId'] as int?,
      entrepotName: json['entrepotName'] as String?,
      orderId: json['orderId'] as int?,
      orderReference: json['orderReference'] as String?,
      isPaid: json['isPaid'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'typeFacture': typeFacture,
      'statusFacture': statusFacture,
      'numeroFacture': numeroFacture,
      'clientId': clientId,
      'entrepotId': entrepotId,
      'orderId': orderId,
      'isPaid': isPaid,
    };
  }
}

