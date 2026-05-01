import '../../../../core/exceptions/validation_exception.dart';
import '../entities/transaction.dart';
import '../repository/i_transaction_repository.dart';
import '../validators/new_transaction_validator.dart';

class SaveTransactionUseCase {
  final ITransactionRepository _repository;

  SaveTransactionUseCase(this._repository);

  Future<void> call({
    required double value,
    required String categoryId,
    required DateTime transactionDate,
    required bool isFixed,
    required bool isPaid,
    String? observation,
    String? finalMonthYear,
  }) async {
    final validationError = NewTransactionValidator.validate(
      value: value,
      categoryId: categoryId,
      transactionDate: transactionDate,
      isFixed: isFixed,
      finalMonthYear: finalMonthYear,
    );

    if (validationError != null) {
      throw ValidationException(validationError);
    }

    final transaction = TransactionEntity.create(
      value: value,
      categoryId: categoryId,
      transactionDate: transactionDate,
      isFixed: isFixed,
      isPaid: isPaid,
      observation: observation,
      finalMonthYear: finalMonthYear,
    );

    await _repository.createTransaction(transaction);
  }
}
