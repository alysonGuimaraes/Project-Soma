import 'package:get_it/get_it.dart';

import '../Presentation/Controllers/transaction_controller.dart';
import 'Database/database_service.dart';
import 'Repositories/transaction_repository_impl.dart';

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