
import '../Entities/Transaction.dart';

abstract class ITransactionRepository {
  Future<List<TransactionEntity>> getTransactionsByMonth(String monthYear);

  Future<List<TransactionEntity>> getFixedTransactions();

  Future<TransactionEntity?> getTransactionById(String id);

  Future<void> createTransaction(TransactionEntity transaction);

  Future<void> updateTransaction(TransactionEntity transaction);

  Future<void> deleteTransaction(String id);
}