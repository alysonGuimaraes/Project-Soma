import 'dart:convert';

import '../../domain/entities/transaction.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    super.id,
    required super.value,
    required super.transactionDate,
    required super.monthYear,
    super.finalMonthYear,
    required super.categoryId,
    super.observation,
    super.isFixed = false,
    super.isPaid = true,
    required super.createdAt,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'value': value,
      'transactionDate': transactionDate.toIso8601String(),
      'monthYear': monthYear,
      'finalMonthYear': finalMonthYear,
      'categoryId': categoryId,
      'observation': observation,
      'isFixed': isFixed ? 1 : 0,
      'isPaid': isPaid ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      value: map['value'],
      transactionDate: DateTime.parse(map['transactionDate']),
      monthYear: map['monthYear'],
      finalMonthYear: map['finalMonthYear'],
      categoryId: map['categoryId'],
      observation: map['observation'],
      isFixed: map['isFixed'] == 1,
      isPaid: map['isPaid'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  factory TransactionModel.fromJson(String json) =>
      TransactionModel.fromMap(jsonDecode(json));
}
