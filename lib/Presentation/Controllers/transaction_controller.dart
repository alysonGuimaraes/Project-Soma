

import '../../Domain/Entities/transaction.dart';
import '../../Domain/Repositories/i_transaction_repository.dart';

class TransactionController {
  final ITransactionRepository _repository;

  TransactionController(this._repository);

  Future<void> saveNewTransaction({
    required double value,
    required String categoryId,
    String? observation,
    required bool isFixed,
    required bool isPaid,
    String? finalMonthYear,
  }) async {

    final now = DateTime.now();

    // Formata o mês/ano atual para formato "MMYYYY"
    final currentMonthYear = "${now.month.toString().padLeft(2, '0')}${now.year}";

    // Cria a entidade pura com os dados recolhidos
    final newTransaction = TransactionEntity(
      id: now.millisecondsSinceEpoch.toString(), // Gera um ID único simples
      value: value,
      transactionDate: now,
      monthYear: currentMonthYear,
      categoryId: categoryId,
      observation: observation,
      isFixed: isFixed,
      isPaid: isPaid,
      finalMonthYear: finalMonthYear, // O novo campo que adicionou
      createdAt: now,
      updatedAt: now,
    );

    await _repository.createTransaction(newTransaction);
  }
}