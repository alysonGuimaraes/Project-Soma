import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/features/movement/data/models/recurrence_model.dart';
import 'package:project_soma/features/movement/domain/entities/recurrence_entity.dart';

void main() {
  //Arrange
  final tRecurrenceModel = RecurrenceModel(
    id: '123e4567-e89b-12d3-a456-426614174002',
    categoryId: '123e4567-e89b-12d3-a456-426614174000',
    value: 45.60,
    frequency: FrequencyType.monthly,
    recurrencyInitDate: DateTime.parse('2026-07-20T10:00:00.000'),
    isActive: true,
    createdAt: DateTime.parse('2026-07-20T10:00:00.000'),
    updatedAt: DateTime.parse('2026-07-20T10:00:00.000'),

    qtdOccurrence: 10,
  );

  final tMap = {
    'id': '123e4567-e89b-12d3-a456-426614174002',
    'categoryId': '123e4567-e89b-12d3-a456-426614174000',
    'value': 45.60,
    'frequency': 'monthly',
    'recurrencyInitDate': '2026-07-20T10:00:00.000',
    'isActive': 1,
    'createdAt': '2026-07-20T10:00:00.000',
    'updatedAt': '2026-07-20T10:00:00.000',

    'qtdOccurrence': 10,
  };

  group('RecurrenceModel Tests', () {
    test('fromMap: Should return a valid RecurrenceModel from a map.', () {
      // Act
      final result = RecurrenceModel.fromMap(tMap);

      // Assert
      expect(tRecurrenceModel, isA<RecurrenceEntity>());

      expect(result.id, equals(tRecurrenceModel.id));
      expect(result.categoryId, equals(tRecurrenceModel.categoryId));
      expect(result.value, equals(tRecurrenceModel.value));
      expect(result.frequency, equals(tRecurrenceModel.frequency));
      expect(
        result.recurrencyInitDate,
        equals(tRecurrenceModel.recurrencyInitDate),
      );
      expect(result.isActive, equals(tRecurrenceModel.isActive));
      expect(result.createdAt, equals(tRecurrenceModel.createdAt));
      expect(result.updatedAt, equals(tRecurrenceModel.updatedAt));

      expect(result.qtdOccurrence, equals(tRecurrenceModel.qtdOccurrence));
    });

    test(
      'toMap: Should return a correctly formatted Map for database storage.',
      () {
        // Act
        final result = tRecurrenceModel.toMap();

        // Assert
        expect(result['isActive'], equals(1));
        expect(result['frequency'], equals('monthly'));
        expect(result, equals(tMap));
      },
    );
  });
}
