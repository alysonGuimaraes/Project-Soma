
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


  // TODO: implementar restante dos métodos das transações
}