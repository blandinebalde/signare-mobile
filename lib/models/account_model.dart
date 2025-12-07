import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final int? id;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? accountType;
  final double? currentBalance;
  final double? availableBalance;
  final String? currency;
  final bool? isActive;
  final DateTime? createdAt;

  const Account({
    this.id,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.accountType,
    this.currentBalance,
    this.availableBalance,
    this.currency,
    this.isActive,
    this.createdAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int?,
      accountName: json['accountName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      bankName: json['bankName'] as String?,
      accountType: json['accountType'] as String?,
      currentBalance: (json['currentBalance'] as num?)?.toDouble(),
      availableBalance: (json['availableBalance'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'XOF',
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'accountType': accountType,
      'currentBalance': currentBalance,
      'availableBalance': availableBalance,
      'currency': currency,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        accountName,
        accountNumber,
        currentBalance,
      ];
}

