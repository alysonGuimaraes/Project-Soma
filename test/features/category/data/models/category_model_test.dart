import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/features/category/data/models/category_model.dart';
import 'package:project_soma/features/category/domain/entities/category_entity.dart';

void main() {
  // Arrange
  final tCategoryModel = CategoryModel(
    id: '123e4567-e89b-12d3-a456-426614174000',
    type: TransactionType.expense,
    name: 'Mercado',
    colorHex: '#FF0000',
    iconCode: 'shopping_cart',
    createdAt: DateTime.parse('2026-07-20T10:00:00.000'),
    updatedAt: DateTime.parse('2026-07-20T10:00:00.000'),
  );

  final tMap = {
    'id': '123e4567-e89b-12d3-a456-426614174000',
    'type': 'expense',
    'name': 'Mercado',
    'colorHex': '#FF0000',
    'iconCode': 'shopping_cart',
    'createdAt': '2026-07-20T10:00:00.000',
    'updatedAt': '2026-07-20T10:00:00.000',
  };

  group('CategoryModel Tests', () {
    test('fromMap: Should return a valid CategoryModel from a map.', () {
      // Act
      final result = CategoryModel.fromMap(tMap);

      // Assert
      expect(tCategoryModel, isA<CategoryEntity>());

      expect(result.id, equals(tCategoryModel.id));
      expect(result.type, equals(tCategoryModel.type));
      expect(result.name, equals(tCategoryModel.name));
      expect(result.colorHex, equals(tCategoryModel.colorHex));
      expect(result.iconCode, equals(tCategoryModel.iconCode));
      expect(result.createdAt, equals(tCategoryModel.createdAt));
      expect(result.updatedAt, equals(tCategoryModel.updatedAt));
    });

    test(
      'toMap: Should return a correctly formatted Map for database storage.',
      () {
        // Act
        final result = tCategoryModel.toMap();

        // Assert
        expect(result, equals(tMap));
      },
    );
  });
}
