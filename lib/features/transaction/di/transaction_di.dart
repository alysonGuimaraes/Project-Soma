import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../core/connection/database_service.dart';
import '../data/repository/transaction_repository_impl.dart';
import '../domain/repository/i_transaction_repository.dart';
import '../domain/usecases/get_transaction_by_monthyear_usecase.dart';
import '../domain/usecases/save_transaction_usecase.dart';
import '../presentation/controllers/transaction_form_controller.dart';
import '../presentation/controllers/transaction_list_controller.dart';

class TransactionDI {
  static Future<List<SingleChildWidget>> providers() async {
    final db = await DatabaseService().database;
    final repository = TransactionRepositoryImpl(db);

    return [
      // Repositório
      Provider<ITransactionRepository>(create: (_) => repository),

      // UseCases
      ProxyProvider<ITransactionRepository, SaveTransactionUseCase>(
        update: (_, repo, _) => SaveTransactionUseCase(repo),
      ),

      ProxyProvider<ITransactionRepository, GetTransactionsByMonthUseCase>(
        update: (_, repo, _) => GetTransactionsByMonthUseCase(repo),
      ),

      // Controllers
      ChangeNotifierProxyProvider<
        SaveTransactionUseCase,
        TransactionFormController
      >(
        create: (_) =>
            TransactionFormController(save: SaveTransactionUseCase(repository)),
        update: (_, save, _) => TransactionFormController(save: save),
      ),

      ChangeNotifierProxyProvider<
        GetTransactionsByMonthUseCase,
        TransactionListController
      >(
        create: (_) => TransactionListController(
          getByMonth: GetTransactionsByMonthUseCase(repository),
        ),
        update: (_, getByMonth, _) =>
            TransactionListController(getByMonth: getByMonth),
      ),
    ];
  }
}
