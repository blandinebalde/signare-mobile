class PaiementDTO {
  final int? id;
  final double? montant;
  final DateTime? datePaiement;
  final String? moyenPaiement; // ESPECES, CARTE_BANCAIRE, VIREMENT, CHEQUE, MOBILE_MONEY
  final String? reference;
  final String? status; // EN_ATTENTE, VALIDE, ANNULE, REJETE
  final String? numeroPaiement;
  final String? typePaiement; // SUR_VENTE, SUR_ACHAT, etc.

  PaiementDTO({
    this.id,
    this.montant,
    this.datePaiement,
    this.moyenPaiement,
    this.reference,
    this.status,
    this.numeroPaiement,
    this.typePaiement,
  });

  factory PaiementDTO.fromJson(Map<String, dynamic> json) {
    return PaiementDTO(
      id: json['id'] as int?,
      montant: (json['montant'] as num?)?.toDouble(),
      datePaiement: json['datePaiement'] != null
          ? (json['datePaiement'] is String
              ? DateTime.parse(json['datePaiement'])
              : json['datePaiement'])
          : null,
      moyenPaiement: json['moyenPaiement'] as String?,
      reference: json['reference'] as String?,
      status: json['status']?.toString(),
      numeroPaiement: json['numeroPaiement'] as String?,
      typePaiement: json['typePaiement'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'datePaiement': datePaiement?.toIso8601String().split('T')[0],
      'moyenPaiement': moyenPaiement,
      'reference': reference,
      'status': status ?? 'VALIDE',
      'numeroPaiement': numeroPaiement,
      'typePaiement': typePaiement ?? 'SUR_FACTURE',
    };
  }
}

class MobileMoney {
  final int? id;
  final String numeroTelephone;
  final String operateur; // Orange Money, MTN Mobile Money, Moov Money, etc.
  final String titulaire;
  final double montant;
  final DateTime? dateTransaction;
  final String? description;

  MobileMoney({
    this.id,
    required this.numeroTelephone,
    required this.operateur,
    required this.titulaire,
    required this.montant,
    this.dateTransaction,
    this.description,
  });

  factory MobileMoney.fromJson(Map<String, dynamic> json) {
    return MobileMoney(
      id: json['id'] as int?,
      numeroTelephone: json['numeroTelephone'] as String,
      operateur: json['operateur'] as String,
      titulaire: json['titulaire'] as String,
      montant: (json['montant'] as num).toDouble(),
      dateTransaction: json['dateTransaction'] != null
          ? (json['dateTransaction'] is String
              ? DateTime.parse(json['dateTransaction'])
              : json['dateTransaction'])
          : null,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroTelephone': numeroTelephone,
      'operateur': operateur,
      'titulaire': titulaire,
      'montant': montant,
      'dateTransaction': dateTransaction?.toIso8601String(),
      'description': description,
    };
  }
}

class Cheque {
  final int? id;
  final String numeroCheque;
  final String banque;
  final String titulaire;
  final double montant;
  final DateTime? dateCheque;
  final String? description;

  Cheque({
    this.id,
    required this.numeroCheque,
    required this.banque,
    required this.titulaire,
    required this.montant,
    this.dateCheque,
    this.description,
  });

  factory Cheque.fromJson(Map<String, dynamic> json) {
    return Cheque(
      id: json['id'] as int?,
      numeroCheque: json['numeroCheque'] as String,
      banque: json['banque'] as String,
      titulaire: json['titulaire'] as String,
      montant: (json['montant'] as num).toDouble(),
      dateCheque: json['dateCheque'] != null
          ? (json['dateCheque'] is String
              ? DateTime.parse(json['dateCheque'])
              : json['dateCheque'])
          : null,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroCheque': numeroCheque,
      'banque': banque,
      'titulaire': titulaire,
      'montant': montant,
      'dateCheque': dateCheque?.toIso8601String(),
      'description': description,
    };
  }
}

class Virement {
  final int? id;
  final String reference;
  final double montant;
  final DateTime? dateVirement;
  final String banque;
  final String numeroCompte;
  final String titulaire;
  final String? description;

  Virement({
    this.id,
    required this.reference,
    required this.montant,
    this.dateVirement,
    required this.banque,
    required this.numeroCompte,
    required this.titulaire,
    this.description,
  });

  factory Virement.fromJson(Map<String, dynamic> json) {
    return Virement(
      id: json['id'] as int?,
      reference: json['reference'] as String,
      montant: (json['montant'] as num).toDouble(),
      dateVirement: json['dateVirement'] != null
          ? (json['dateVirement'] is String
              ? DateTime.parse(json['dateVirement'])
              : json['dateVirement'])
          : null,
      banque: json['banque'] as String,
      numeroCompte: json['numeroCompte'] as String,
      titulaire: json['titulaire'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'montant': montant,
      'dateVirement': dateVirement?.toIso8601String(),
      'banque': banque,
      'numeroCompte': numeroCompte,
      'titulaire': titulaire,
      'description': description,
    };
  }
}

class FactureWithPaiemeentDTO {
  final Map<String, dynamic>? client;
  final Map<String, dynamic>? income;
  final List<Map<String, dynamic>>? detailIncomes;
  final PaiementDTO? paiement;
  final MobileMoney? mobileMoney;
  final Cheque? cheque;
  final Virement? virement;

  FactureWithPaiemeentDTO({
    this.client,
    this.income,
    this.detailIncomes,
    this.paiement,
    this.mobileMoney,
    this.cheque,
    this.virement,
  });

  Map<String, dynamic> toJson() {
    return {
      'client': client,
      'income': income,
      'detailIncomes': detailIncomes,
      'paiement': paiement?.toJson(),
      'mobileMoney': mobileMoney?.toJson(),
      'cheque': cheque?.toJson(),
      'virement': virement?.toJson(),
    };
  }
}

