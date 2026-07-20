import 'package:project_soma/features/movement/domain/entities/recurrence_entity.dart';

class RecurrenceModel extends RecurrenceEntity {
  RecurrenceModel({
    required super.id,
    required super.categoryId,
    required super.value,
    required super.frequency,
    required super.recurrencyInitDate,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,

    super.qtdOccurrence,
  });

  factory RecurrenceModel.fromMap(Map<String, dynamic> map) {
    return RecurrenceModel(
      id: map['id'],
      categoryId: map['categoryId'],
      value: (map['value'] as num).toDouble(),
      frequency: FrequencyType.values.firstWhere(
        (e) => e.name == map['frequency'],
      ),
      recurrencyInitDate: DateTime.parse(map['recurrencyInitDate']),
      isActive: map['isActive'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),

      qtdOccurrence: map['qtdOccurrence'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'value': value,
      'frequency': frequency.name,
      'recurrencyInitDate': recurrencyInitDate.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),

      'qtdOccurrence': qtdOccurrence,
    };
  }
}
