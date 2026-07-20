import 'package:project_soma/features/movement/domain/entities/movement_entity.dart';

class MovementModel extends MovementEntity {
  MovementModel({
    required super.id,
    required super.categoryId,
    required super.value,
    required super.movementDate,
    required super.createdAt,
    required super.updatedAt,

    super.note,
    super.recurrenceId,
  });

  factory MovementModel.fromMap(Map<String, dynamic> map) {
    return MovementModel(
      id: map['id'],
      categoryId: map['categoryId'],
      value: (map['value'] as num).toDouble(),
      movementDate: map['movementDate'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),

      note: map['note'],
      recurrenceId: map['recurrenceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'value': value,
      'movementDate': movementDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'note': note,
      'recurrenceId': recurrenceId,
    };
  }
}
