import 'package:mockito/annotations.dart';
import 'package:project_soma/features/transaction/domain/repository/i_transaction_repository.dart';
import 'package:project_soma/features/transaction/presentation/controller/transaction_form_controller.dart';

@GenerateNiceMocks([
  MockSpec<ITransactionRepository>(),
  MockSpec<TransactionFormController>(),
])
void main() {}
