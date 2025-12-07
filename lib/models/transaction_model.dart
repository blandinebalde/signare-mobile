import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int? id;
  final String? transactionType; // INCOME, EXPENSE
  final double? amount;
  final String? description;
  final int? accountId;
  final String? accountName;
  final DateTime? transactionDate;
  final String? category;
  final String? reference;

  const Transaction({
    this.id,
    this.transactionType,
    this.amount,
    this.description,
    this.accountId,
    this.accountName,
    this.transactionDate,
    this.category,
    this.reference,
  });

  bool get isIncome => transactionType == 'INCOME';
  bool get isExpense => transactionType == 'EXPENSE';

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int?,
      transactionType: json['transactionType'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      accountId: json['accountId'] as int?,
      accountName: json['accountName'] as String?,
      transactionDate: json['transactionDate'] != null
          ? DateTime.parse(json['transactionDate'] as String)
          : null,
      category: json['category'] as String?,
      reference: json['reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionType': transactionType,
      'amount': amount,
      'description': description,
      'accountId': accountId,
      'accountName': accountName,
      'transactionDate': transactionDate?.toIso8601String(),
      'category': category,
      'reference': reference,
    };
  }

  @override
  List<Object?> get props => [
        id,
        transactionType,
        amount,
        transactionDate,
      ];
}

