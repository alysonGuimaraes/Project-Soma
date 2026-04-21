import 'package:get_it/get_it.dart';

import '../../../core/connection/database_service.dart';
import '../data/repository/transaction_repository_impl.dart';
import '../service/transaction_service.dart';

final getIt = GetIt.instance;

void setupDataDependencies() {
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());

  getIt.registerLazySingletonAsync<TransactionRepositoryImpl>(
    () async =>
        TransactionRepositoryImpl(await getIt<DatabaseService>().database),
  );

  getIt.registerLazySingletonAsync<TransactionService>(
    () async =>
        TransactionService(await getIt.getAsync<TransactionRepositoryImpl>()),
  );
}
