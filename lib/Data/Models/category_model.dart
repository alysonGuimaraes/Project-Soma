
import 'dart:convert';

import 'package:project_soma/Domain/Entities/category.dart';

class CategoryModel extends CategoryEntity{
  CategoryModel({
    required super.id,
    required super.description,
    required super.type,
    super.colorHex,
    super.iconCode,
    required super.createdAt,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'description': description,
      'type': type.name,
      'colorHex': colorHex,
      'iconCode': iconCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String()
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map){
    return CategoryModel(
        id: map['id'],
        description: map['description'],
        type: TransactionType.values.byName(map['type']),
        colorHex: map['colorHex'],
        iconCode: map['iconCode'],
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt'])
    );
  }

  factory CategoryModel.fromJson(String json) => CategoryModel.fromMap(jsonDecode(json));
}