class Order {
  final int? id;
  final String? reference;
  final String? numeroCommande;
  final DateTime? dateCommande;
  final String? status; // PENDING, CONFIRMED, IN_PROGRESS, DELIVERED, CANCELLED
  final double? montantTotal;
  final double? totalAmount;
  final int? entrepotId;
  final String? entrepotName;
  final int? clientId;
  final String? clientName;
  final String? nomClient;
  final String? clientPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem>? items;

  Order({
    this.id,
    this.reference,
    this.numeroCommande,
    this.dateCommande,
    this.status,
    this.montantTotal,
    this.totalAmount,
    this.entrepotId,
    this.entrepotName,
    this.clientId,
    this.clientName,
    this.nomClient,
    this.clientPhone,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Gérer les deux formats possibles : 'items' ou 'productOrders'
    List<OrderItem>? orderItems;
    if (json['items'] != null) {
      orderItems = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (json['productOrders'] != null) {
      // Si le backend renvoie 'productOrders', les convertir en OrderItem
      orderItems = (json['productOrders'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    // Gérer le statut (peut être un enum ou une string)
    String? statusValue;
    if (json['status'] != null) {
      statusValue = json['status'].toString();
    } else if (json['statut'] != null) {
      statusValue = json['statut'].toString();
    }
    
    // Gérer le montant total (peut être montantTotal ou totalAmount)
    double? montant = (json['montantTotal'] as num?)?.toDouble() 
        ?? (json['totalAmount'] as num?)?.toDouble();
    
    // Gérer le client (peut être un objet ou des champs directs)
    int? clientIdValue;
    String? clientNameValue;
    String? clientPhoneValue;
    
    if (json['client'] != null && json['client'] is Map) {
      final client = json['client'] as Map<String, dynamic>;
      clientIdValue = client['id'] as int?;
      clientNameValue = client['nom'] as String? ?? client['name'] as String?;
      clientPhoneValue = client['telephone'] as String? ?? client['phone'] as String?;
    } else {
      clientIdValue = json['clientId'] as int?;
      clientNameValue = json['clientName'] as String? ?? json['nomClient'] as String?;
      clientPhoneValue = json['clientPhone'] as String?;
    }
    
    // Gérer l'entrepôt (peut être un objet ou des champs directs)
    int? entrepotIdValue;
    String? entrepotNameValue;
    
    if (json['entrepot'] != null && json['entrepot'] is Map) {
      final entrepot = json['entrepot'] as Map<String, dynamic>;
      entrepotIdValue = entrepot['id'] as int?;
      entrepotNameValue = entrepot['nom'] as String? ?? entrepot['name'] as String?;
    } else {
      entrepotIdValue = json['entrepotId'] as int?;
      entrepotNameValue = json['entrepotName'] as String?;
    }
    
    return Order(
      id: json['id'] as int?,
      reference: json['reference'] as String? ?? json['numeroCommande'] as String?,
      numeroCommande: json['numeroCommande'] as String?,
      dateCommande: json['dateCommande'] != null
          ? (json['dateCommande'] is String 
              ? DateTime.parse(json['dateCommande'] as String)
              : DateTime.fromMillisecondsSinceEpoch(json['dateCommande'] as int))
          : null,
      status: statusValue,
      montantTotal: montant,
      totalAmount: montant,
      entrepotId: entrepotIdValue,
      entrepotName: entrepotNameValue,
      clientId: clientIdValue,
      clientName: clientNameValue,
      nomClient: clientNameValue,
      clientPhone: clientPhoneValue,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is String 
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int))
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is String 
              ? DateTime.parse(json['updatedAt'] as String)
              : DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int))
          : null,
      items: orderItems,
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
  final String? productImagePath;
  final int quantity;
  final double? prixUnitaire;
  final double? montantTotal;

  OrderItem({
    this.id,
    this.productId,
    this.productName,
    this.productImagePath,
    required this.quantity,
    this.prixUnitaire,
    this.montantTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Gérer les différents formats possibles du backend
    // Le backend peut renvoyer 'product' comme objet avec 'id', 'name' et 'imagePath'
    String? productName;
    String? productImagePath;
    int? productId;
    
    if (json['product'] != null && json['product'] is Map) {
      final product = json['product'] as Map<String, dynamic>;
      
      // Si c'est un EntrepotProduct, il peut avoir un objet 'product' imbriqué
      if (product['product'] != null && product['product'] is Map) {
        final innerProduct = product['product'] as Map<String, dynamic>;
        productId = innerProduct['id'] as int?;
        productName = innerProduct['name'] as String? 
            ?? innerProduct['nom'] as String?
            ?? innerProduct['productName'] as String?;
        productImagePath = innerProduct['imagePath'] as String?;
      } else {
        // Sinon, les infos sont directement dans l'objet product
        productId = product['id'] as int?;
        productName = product['name'] as String? 
            ?? product['nom'] as String?
            ?? product['productName'] as String?;
        productImagePath = product['imagePath'] as String?;
      }
    } else {
      // Les infos sont dans les champs directs
      productId = json['productId'] as int?;
      productName = json['productName'] as String? 
          ?? json['nomProduit'] as String?
          ?? json['name'] as String?;
      productImagePath = json['productImagePath'] as String? 
          ?? json['imagePath'] as String?;
    }
    
    // Gérer les différents noms de champs pour le prix
    double? prixUnitaire = (json['prixUnitaire'] as num?)?.toDouble() 
        ?? (json['unitPrice'] as num?)?.toDouble()
        ?? (json['prix'] as num?)?.toDouble()
        ?? (json['price'] as num?)?.toDouble();
    
    // Gérer les différents noms de champs pour le montant total
    // Calculer le montant total si non fourni
    double? montantTotal = (json['montantTotal'] as num?)?.toDouble()
        ?? (json['totalAmount'] as num?)?.toDouble()
        ?? (json['montant'] as num?)?.toDouble()
        ?? (json['subtotal'] as num?)?.toDouble();
    
    // Si le montant total n'est pas fourni, le calculer
    if (montantTotal == null && prixUnitaire != null) {
      final qty = json['quantity'] as int? ?? json['quantite'] as int? ?? 0;
      montantTotal = prixUnitaire * qty;
    }
    
    return OrderItem(
      id: json['id'] as int?,
      productId: productId,
      productName: productName,
      productImagePath: productImagePath,
      quantity: json['quantity'] as int? ?? json['quantite'] as int? ?? 0,
      prixUnitaire: prixUnitaire,
      montantTotal: montantTotal,
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

