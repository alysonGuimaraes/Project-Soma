
import 'package:project_soma/Data/Models/transaction_model.dart';
import 'package:project_soma/Domain/Entities/transaction.dart';
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
  Future<void> deleteTransaction(String id) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionEntity>> getFixedTransactions() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'Transactions',
      where: 'isFixed = ?',
      whereArgs: [1],
    );

    return maps.map((map) => TransactionModel.fromMap(map)).toList();
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
  Future<List<TransactionEntity>> getTransactionsByMonth(String monthYear) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'Transactions',
      where: 'monthYear = ?',
      whereArgs: [monthYear],
      orderBy: 'transactionDate DESC',
    );

    return maps.map((map) => TransactionModel.fromMap(map)).toList();
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

}