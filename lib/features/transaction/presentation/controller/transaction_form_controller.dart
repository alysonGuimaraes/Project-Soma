import 'package:flutter/cupertino.dart';

import '../../domain/usecases/save_transaction_usecase.dart';

class TransactionFormController extends ChangeNotifier {
  final SaveTransactionUseCase _save;

  TransactionFormController({required SaveTransactionUseCase save})
    : _save = save;

  bool isSubmitting = false;
  String? error;
  bool success = false;

  Future<void> save({
    required double value,
    required String categoryId,
    required DateTime transactionDate,
    required bool isFixed,
    required bool isPaid,
    String? observation,
    String? finalMonthYear,
  }) async {
    isSubmitting = true;
    error = null;
    success = false;
    notifyListeners();

    try {
      await _save.call(
        value: value,
        categoryId: categoryId,
        transactionDate: transactionDate,
        isFixed: isFixed,
        isPaid: isPaid,
        observation: observation,
        finalMonthYear: finalMonthYear,
      );
      success = true;
    } catch (e) {
      error = 'Erro ao salvar transação';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
