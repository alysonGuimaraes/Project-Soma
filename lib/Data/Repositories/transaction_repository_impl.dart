
import 'package:project_soma/Data/Models/transaction_model.dart';
import 'package:project_soma/Domain/Entities/transaction.dart';
import 'package:project_soma/Domain/Entities/transaction_filter.dart';
import 'package:project_soma/Domain/Repositories/i_transaction_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TransactionRepositoryImpl extends ITransactionRepository {
  final Database _database;

  TransactionRepositoryImpl(this._database);

  @override
  Future<void> createTransaction(TransactionEntity transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      value: transaction.value,
      transactionDate: transaction.transactionDate,
      monthYear: transaction.monthYear,
      finalMonthYear: transaction.finalMonthYear,
      categoryId: transaction.categoryId,
      observation: transaction.observation,
      isFixed: transaction.isFixed,
      isPaid: transaction.isPaid,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );

    await _database.insert(
      'Transactions',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _database.delete(
      'Transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      value: transaction.value,
      transactionDate: transaction.transactionDate,
      monthYear: transaction.monthYear,
      categoryId: transaction.categoryId,
      observation: transaction.observation,
      isFixed: transaction.isFixed,
      isPaid: transaction.isPaid,
      createdAt: transaction.createdAt,
      updatedAt: DateTime.now(),
    );

    await _database.update(
      'Transactions',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<TransactionEntity?> getTransactionById(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'Transactions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TransactionModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<TransactionEntity>?> getTransactionsByFilter(TransactionFilter filter) async {
    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    if (filter.minValue != null) {
      whereClauses.add('value >= ?');
      whereArgs.add(filter.minValue);
    }

    if (filter.maxValue != null) {
      whereClauses.add('value <= ?');
      whereArgs.add(filter.maxValue);
    }

    if (filter.monthYear != null) {
      whereClauses.add('monthYear = ?');
      whereArgs.add(filter.monthYear);
    }

    if (filter.categoryId != null) {
      // TODO: implementar receber lista de categorias de ID
      whereClauses.add('categoryId = ?');
      whereArgs.add(filter.categoryId);
    }

    if (filter.isFixed != null) {
      whereClauses.add('isFixed = ?');
      whereArgs.add(filter.isFixed! ? 1 : 0);
    }

    if (filter.isPaid != null) {
      whereClauses.add('isPaid = ?');
      whereArgs.add(filter.isPaid! ? 1 : 0);
    }

    if (filter.startDate != null) {
      whereClauses.add('transactionDate >= ?');
      whereArgs.add(filter.startDate!.toIso8601String());
    }

    if (filter.endDate != null) {
      whereClauses.add('transactionDate <= ?');
      whereArgs.add(filter.endDate!.toIso8601String());
    }

    String? finalWhere = whereClauses.isEmpty ? null : whereClauses.join(' AND ');

    List<dynamic>? finalWhereArgs = whereArgs.isNotEmpty ? whereArgs : null;

    final List<Map<String, dynamic>> maps = await _database.query(
      'Transactions',
      where: finalWhere,
      whereArgs: finalWhereArgs,
      orderBy: 'transactionDate DESC',
    );

    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<List<TransactionEntity>?> getTransactionsByMonthYear(String monthYear) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'Transactions',
      where: 'monthYear = ?',
      whereArgs: [monthYear],
    );

    if (maps.isNotEmpty) {
      return maps.map((map) => TransactionModel.fromMap(map)).toList();
    }
    return null;
  }

}