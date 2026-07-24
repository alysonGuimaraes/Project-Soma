import '../entities/recurrence_entity.dart';

abstract class IRecurrenceRepository {
  Future<void> createRecurrence(RecurrenceEntity category);

  Future<List<RecurrenceEntity>?> getAllRecurrences();
  Future<RecurrenceEntity?> getRecurrenceById(String id);

  Future<void> updateRecurrence(RecurrenceEntity category);
  Future<void> updateAllRecurrencesInCategory(
    String categoryId,
    Map<String, dynamic> params,
  );

  Future<void> deleteRecurrence(String id);
}
