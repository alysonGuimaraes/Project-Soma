import 'package:get_it/get_it.dart';

import '../connection/database_connection.dart';

void initCoreDI() {
  final dc = GetIt.instance;

  dc.registerLazySingleton<DatabaseConnection>(() => DatabaseConnection());
}
