enum FrequencyType { annual, monthly, weekly, daily }

class RecurrenceEntity {
  final String id;
  final String categoryId;
  final double value;
  final FrequencyType frequency;
  final DateTime recurrencyInitDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int? qtdOccurrence;

  RecurrenceEntity({
    required this.id,
    required this.categoryId,
    required this.value,
    required this.frequency,
    required this.recurrencyInitDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,

    this.qtdOccurrence,
  });
}
