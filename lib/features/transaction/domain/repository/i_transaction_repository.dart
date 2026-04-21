import '../entities/transaction.dart';
import '../entities/transaction_filter.dart';

abstract class ITransactionRepository {
  Future<List<TransactionEntity>?> getTransactionsByFilter(
    TransactionFilter filter,
  );

  Future<TransactionEntity?> getTransactionById(int id);

  Future<List<TransactionEntity>> getTransactionsByMonthYear(String monthYear);

  Future<void> createTransaction(TransactionEntity transaction);

  Future<void> updateTransaction(TransactionEntity transaction);

  Future<void> deleteTransaction(int id);
}
