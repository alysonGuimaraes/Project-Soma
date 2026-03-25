
import 'package:project_soma/Domain/Entities/transaction_filter.dart';
import '../../Domain/Entities/transaction.dart';
import '../../Domain/Repositories/i_transaction_repository.dart';

class TransactionController {
  final ITransactionRepository _repository;

  TransactionController(this._repository);

  Future<void> saveNewTransaction({
    required double value,
    required String categoryId,
    required DateTime transactionDate,
    String? observation,
    required bool isFixed,
    required bool isPaid,
    String? finalMonthYear,
  }) async {

    final now = DateTime.now();

    final currentMonthYear = "${now.month.toString().padLeft(2, '0')}${now.year}";

    // TODO: Ajustar criacao de id unico via banco mesmo
    final newTransaction = TransactionEntity(
      id: now.millisecondsSinceEpoch.toString(), // ID único simples
      value: value,
      transactionDate: transactionDate,
      monthYear: currentMonthYear,
      categoryId: categoryId,
      observation: observation,
      isFixed: isFixed,
      isPaid: isPaid,
      finalMonthYear: finalMonthYear,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.createTransaction(newTransaction);
  }


  Future<void> deleteTransaction (String id) async {
    await _repository.deleteTransaction(id);
  }

  Future<void> updateTransaction ({
      required String id,
      required double value,
      required String categoryId,
      required DateTime transactionDate,
      String? observation,
      required bool isFixed,
      required bool isPaid,
      String? finalMonthYear
  }) async {

    final oldTransaction = await _repository.getTransactionById(id);

    if (oldTransaction == null) {
      throw Exception('Transação não encontrada no banco de dados!');
    }

    final now = DateTime.now();

    final currentMonthYear = "${now.month.toString().padLeft(2, '0')}${now.year}";

    final updatedTransaction = TransactionEntity(
      id: oldTransaction.id,
      value: value,
      transactionDate: transactionDate,
      monthYear: currentMonthYear,
      categoryId: categoryId,
      observation: observation,
      isFixed: isFixed,
      isPaid: isPaid,
      finalMonthYear: finalMonthYear,
      createdAt: oldTransaction.createdAt,
      updatedAt: now,
    );

    await _repository.updateTransaction(updatedTransaction);
  }

  Future<List<TransactionEntity>?> getTransactionsByMonthYear (String monthYear) async {
    final transactionList = await _repository.getTransactionsByMonthYear(monthYear);

    return transactionList;
  }

  Future<List<TransactionEntity>?> getTransactionsByFilter (TransactionFilter filter) async {
    final transactionsList = await _repository.getTransactionsByFilter(filter);

    return transactionsList;
  }

  Future<TransactionEntity?> getTransactionById (String id) async {
    final transaction = await _repository.getTransactionById(id);

    return transaction;
  }
}