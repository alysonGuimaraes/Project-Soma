import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/features/movement/data/models/movement_model.dart';
import 'package:project_soma/features/movement/domain/entities/movement_entity.dart';

void main() {
  //Arrange
  final tMovementModel = MovementModel(
    id: '123e4567-e89b-12d3-a456-426614174001',
    categoryId: '123e4567-e89b-12d3-a456-426614174000',
    value: 45.60,
    movementDate: DateTime.parse('2026-07-20T10:00:00.000'),
    createdAt: DateTime.parse('2026-07-20T10:00:00.000'),
    updatedAt: DateTime.parse('2026-07-20T10:00:00.000'),

    note: 'Test note',
    recurrenceId: '123e4567-e89b-12d3-a456-426614174002',
  );

  final tMap = {
    'id': '123e4567-e89b-12d3-a456-426614174001',
    'categoryId': '123e4567-e89b-12d3-a456-426614174000',
    'value': 45.60,
    'movementDate': '2026-07-20T10:00:00.000',
    'createdAt': '2026-07-20T10:00:00.000',
    'updatedAt': '2026-07-20T10:00:00.000',

    'note': 'Test note',
    'recurrenceId': '123e4567-e89b-12d3-a456-426614174002',
  };

  group('MovementModel Tests', () {
    test('fromMap: Should return a valid MovementModel from a map.', () {
      // Act
      final result = MovementModel.fromMap(tMap);

      // Assert
      expect(tMovementModel, isA<MovementEntity>());

      expect(result.id, equals(tMovementModel.id));
      expect(result.categoryId, equals(tMovementModel.categoryId));
      expect(result.value, equals(tMovementModel.value));
      expect(result.createdAt, equals(tMovementModel.createdAt));
      expect(result.updatedAt, equals(tMovementModel.updatedAt));

      expect(result.note, equals(tMovementModel.note));
      expect(result.recurrenceId, equals(tMovementModel.recurrenceId));
    });

    test(
      'toMap: Should return a correctly formatted Map for database storage.',
      () {
        // Act
        final result = tMovementModel.toMap();

        // Assert
        expect(result, equals(tMap));
      },
    );
  });
}
