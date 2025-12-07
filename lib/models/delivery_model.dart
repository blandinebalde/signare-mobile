class Delivery {
  final int? id;
  final String? reference;
  final DateTime? dateLivraison;
  final String? status; // EN_ATTENTE, EN_COURS, LIVREE, ANNULEE, RETOURNE
  final int? orderId;
  final String? orderReference;
  final String? clientName;
  final String? clientAddress;
  final String? clientPhone;
  final String? livreurName;
  final int? livreurId;
  final int? userId;
  final double? montantTotal;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? nomLivraison;
  final String? prenomLivraison;
  final String? adresseLivraison;
  final String? numeroTelephone;
  final String? statutLivraison;
  final String? commandeNumero;
  final String? description;
  final DateTime? deliveryDate;

  Delivery({
    this.id,
    this.reference,
    this.dateLivraison,
    this.status,
    this.orderId,
    this.orderReference,
    this.clientName,
    this.clientAddress,
    this.clientPhone,
    this.livreurName,
    this.livreurId,
    this.userId,
    this.montantTotal,
    this.createdAt,
    this.updatedAt,
    this.nomLivraison,
    this.prenomLivraison,
    this.adresseLivraison,
    this.numeroTelephone,
    this.statutLivraison,
    this.commandeNumero,
    this.description,
    this.deliveryDate,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    // Gérer les deux formats possibles (ancien et nouveau)
    final statusValue = json['statutLivraison'] ?? json['status'];
    final dateValue = json['dateLivraison'] ?? json['deliveryDate'];
    
    return Delivery(
      id: json['id'] as int?,
      reference: json['reference'] as String?,
      dateLivraison: dateValue != null
          ? (dateValue is String ? DateTime.parse(dateValue) : dateValue)
          : null,
      status: statusValue is String? ? statusValue : statusValue?.toString(),
      statutLivraison: statusValue is String? ? statusValue : statusValue?.toString(),
      orderId: json['orderId'] ?? json['commandeId'] as int?,
      orderReference: json['orderReference'] as String?,
      commandeNumero: json['commandeNumero'] as String?,
      clientName: json['clientName'] ?? json['nomLivraison'] as String?,
      clientAddress: json['clientAddress'] ?? json['adresseLivraison'] as String?,
      clientPhone: json['clientPhone'] ?? json['numeroTelephone'] as String?,
      livreurName: json['livreurName'] as String?,
      livreurId: json['livreurId'] ?? json['userId'] as int?,
      userId: json['userId'] as int?,
      montantTotal: (json['montantTotal'] ?? json['fraisLivraison'] as num?)?.toDouble(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is String ? DateTime.parse(json['createdAt']) : json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is String ? DateTime.parse(json['updatedAt']) : json['updatedAt'])
          : null,
      nomLivraison: json['nomLivraison'] as String?,
      prenomLivraison: json['prenomLivraison'] as String?,
      adresseLivraison: json['adresseLivraison'] as String?,
      numeroTelephone: json['numeroTelephone'] as String?,
      description: json['description'] as String?,
      deliveryDate: json['deliveryDate'] != null
          ? (json['deliveryDate'] is String ? DateTime.parse(json['deliveryDate']) : json['deliveryDate'] as DateTime?)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'dateLivraison': dateLivraison?.toIso8601String(),
      'status': status ?? statutLivraison,
      'statutLivraison': statutLivraison ?? status,
      'orderId': orderId,
      'commandeId': orderId,
      'commandeNumero': commandeNumero,
      'clientName': clientName ?? nomLivraison,
      'nomLivraison': nomLivraison ?? clientName,
      'clientAddress': clientAddress ?? adresseLivraison,
      'adresseLivraison': adresseLivraison ?? clientAddress,
      'clientPhone': clientPhone ?? numeroTelephone,
      'numeroTelephone': numeroTelephone ?? clientPhone,
      'livreurId': livreurId ?? userId,
      'userId': userId ?? livreurId,
      'montantTotal': montantTotal,
      'description': description,
    };
  }
  
  // Getter pour obtenir le nom complet du client
  String get fullClientName {
    if (nomLivraison != null && prenomLivraison != null) {
      return '$nomLivraison $prenomLivraison';
    }
    return clientName ?? nomLivraison ?? 'Client';
  }
  
  // Getter pour obtenir l'adresse
  String get address {
    return adresseLivraison ?? clientAddress ?? 'Adresse non spécifiée';
  }
}

