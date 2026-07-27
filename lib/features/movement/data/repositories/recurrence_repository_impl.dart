import 'package:project_soma/core/connection/database_connection.dart';
import 'package:project_soma/features/movement/domain/entities/recurrence_entity.dart';
import 'package:project_soma/features/movement/domain/repositories/i_recurrence_repository.dart';

class RecurrenceRepositoryImpl implements IRecurrenceRepository {
  final DatabaseConnection databaseConnection;

  RecurrenceRepositoryImpl(this.databaseConnection);

  @override
  Future<void> createRecurrence(RecurrenceEntity category) {
    // TODO: implement createRecurrence
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecurrence(String id) {
    // TODO: implement deleteRecurrence
    throw UnimplementedError();
  }

  @override
  Future<List<RecurrenceEntity>?> getAllRecurrences() {
    // TODO: implement getAllRecurrences
    throw UnimplementedError();
  }

  @override
  Future<RecurrenceEntity?> getRecurrenceById(String id) {
    // TODO: implement getRecurrenceById
    throw UnimplementedError();
  }

  @override
  Future<void> updateAllRecurrencesInCategory(
    String categoryId,
    Map<String, dynamic> params,
  ) {
    // TODO: implement updateAllRecurrencesInCategory
    throw UnimplementedError();
  }

  @override
  Future<void> updateRecurrence(RecurrenceEntity category) {
    // TODO: implement updateRecurrence
    throw UnimplementedError();
  }
}
