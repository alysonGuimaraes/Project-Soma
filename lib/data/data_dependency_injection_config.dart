import 'package:get_it/get_it.dart';

import '../presentation/controllers/transaction_controller.dart';
import 'database/database_service.dart';
import 'repositories/transaction_repository_impl.dart';

final getIt = GetIt.instance;

void setupDataDependencies() {
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());

  getIt.registerLazySingletonAsync<TransactionRepositoryImpl>(
        () async => TransactionRepositoryImpl(await getIt<DatabaseService>().database),
  );

  getIt.registerLazySingletonAsync<TransactionController>(
        () async => TransactionController(await getIt.getAsync<TransactionRepositoryImpl>()),
  );
}