import 'package:get_it/get_it.dart';
import 'package:project_soma/core/connection/database_connection.dart';
import 'package:project_soma/features/movement/data/repositories/movement_repository_impl.dart';
import 'package:project_soma/features/movement/data/repositories/recurrence_repository_impl.dart';
import 'package:project_soma/features/movement/domain/repositories/i_movement_repository.dart';
import 'package:project_soma/features/movement/domain/repositories/i_recurrence_repository.dart';

void initMovementDI() {
  final dc = GetIt.instance;

  dc.registerLazySingleton<IMovementRepository>(
    () => MovementRepositoryImpl(dc<DatabaseConnection>()),
  );

  dc.registerLazySingleton<IRecurrenceRepository>(
    () => RecurrenceRepositoryImpl(dc<DatabaseConnection>()),
  );
}
