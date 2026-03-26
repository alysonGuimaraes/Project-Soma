import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/data/models/transaction_model.dart';

void main() {
  group('TransactionModel |', () {
    final tDate = DateTime(2026, 3, 16, 10, 0, 0);

    final tModel = TransactionModel(
      id: '12345',
      value: 150.50,
      transactionDate: tDate,
      monthYear: '03/2026',
      categoryId: 'cat_1',
      observation: 'Unit Test',
      isFixed: true,
      isPaid: false,
      createdAt: tDate,
      updatedAt: tDate,
    );

    test('Should convert the model to a SQLite-compatible Map (toMap)', () {
      final result = tModel.toMap();

      expect(result['id'], '12345');
      expect(result['value'], 150.50);
      expect(result['monthYear'], '03/2026');

      expect(
        result['isFixed'],
        1,
        reason: 'The boolean true must be converted to 1',
      );
      expect(
        result['isPaid'],
        0,
        reason: 'The boolean false must be converted to 0',
      );
      expect(
        result['transactionDate'],
        tDate.toIso8601String(),
        reason: 'The date must be in ISO8601 format',
      );
    });

    test(
      'Should convert a SQLite Map (fromMap) back into a TransactionModel',
      () {
        // Arrange (Simulating the Map returned by the database)
        final mapFromDatabase = {
          'id': '999',
          'value': 89.90,
          'transactionDate': tDate.toIso8601String(),
          'monthYear': '03/2026',
          'categoryId': 'cat_2',
          'observation': null,
          'isFixed': 0,
          'isPaid': 1,
          'createdAt': tDate.toIso8601String(),
          'updatedAt': tDate.toIso8601String(),
        };

        final result = TransactionModel.fromMap(mapFromDatabase);

        expect(result.id, '999');
        expect(result.value, 89.90);
        expect(result.observation, isNull);

        expect(
          result.isFixed,
          false,
          reason: 'The value 0 from the database must become false',
        );
        expect(
          result.isPaid,
          true,
          reason: 'The value 1 from the database must become true',
        );
        expect(result.transactionDate, equals(tDate));
      },
    );
  });
}
