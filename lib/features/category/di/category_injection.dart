import 'package:get_it/get_it.dart';
import 'package:project_soma/features/category/data/repositories/category_repository_impl.dart';
import 'package:project_soma/features/category/domain/repositories/i_category_repository.dart';

import '../../../core/connection/database_connection.dart';

void initCategoryDI() {
  final dc = GetIt.instance;

  dc.registerLazySingleton<ICategoryRepository>(
    () => CategoryRepositoryImpl(dc<DatabaseConnection>()),
  );
}
