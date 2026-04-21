import 'package:flutter/cupertino.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_transaction_by_monthyear_usecase.dart';

class TransactionListController extends ChangeNotifier {
  final GetTransactionsByMonthUseCase _getByMonth;

  TransactionListController({required GetTransactionsByMonthUseCase getByMonth})
    : _getByMonth = getByMonth;

  List<TransactionEntity>? transactions = [];
  bool isLoading = false;
  String? error;

  Future<void> loadByMonth(String monthYear) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      transactions = await _getByMonth.call(monthYear);
    } catch (e) {
      error = 'Erro ao carregar transações';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
