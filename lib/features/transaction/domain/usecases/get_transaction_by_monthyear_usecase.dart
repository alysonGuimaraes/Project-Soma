import '../entities/transaction.dart';
import '../repository/i_transaction_repository.dart';

class GetTransactionsByMonthUseCase {
  final ITransactionRepository _repository;

  GetTransactionsByMonthUseCase(this._repository);

  Future<List<TransactionEntity>?> call(String monthYear) async {
    return await _repository.getTransactionsByMonthYear(monthYear);
  }
}
