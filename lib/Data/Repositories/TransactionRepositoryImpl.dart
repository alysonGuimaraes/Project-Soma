
import 'package:project_soma/Data/Models/TransactionModel.dart';
import 'package:project_soma/Domain/Repositories/ITransactionRepository.dart';

class TransactionRepositoryImpl extends ITransactionRepository {

  @override
  Future<void> createTransaction(TransactionModel transaction) {
    // TODO: implement createTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTransaction(String id) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getFixedTransactions() {
    // TODO: implement getFixedTransactions
    throw UnimplementedError();
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByMonth(String monthYear) {
    // TODO: implement getTransactionsByMonth
    throw UnimplementedError();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }

}