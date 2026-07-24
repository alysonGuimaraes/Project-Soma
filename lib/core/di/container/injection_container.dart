import 'package:get_it/get_it.dart';
import 'package:project_soma/core/di/core_injection.dart';
import 'package:project_soma/features/category/di/category_injection.dart';

import '../../../features/movement/di/movement_injection.dart';
import '../../connection/database_connection.dart';

// Global dependency container instance.
final dc = GetIt.instance;

Future<void> setupDependencies() async {
  // Register core dependencies.
  initCoreDI();

  // Register feature dependencies.
  initMovementDI();
  initCategoryDI();

  // Initialize the database before the application starts.
  await dc<DatabaseConnection>().database;
}
