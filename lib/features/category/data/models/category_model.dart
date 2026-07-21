import 'package:project_soma/features/category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.type,
    required super.name,
    required super.colorHex,
    required super.iconCode,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      type: TransactionType.values.firstWhere((e) => e.name == map['type']),
      name: map['name'],
      colorHex: map['colorHex'],
      iconCode: map['iconCode'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'colorHex': colorHex,
      'iconCode': iconCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
