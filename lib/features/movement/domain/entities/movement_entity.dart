class MovementEntity {
  final String id;
  final String categoryId;
  final double value;
  final DateTime movementDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? note;
  final String? recurrenceId;

  MovementEntity({
    required this.id,
    required this.categoryId,
    required this.value,
    required this.movementDate,
    required this.createdAt,
    required this.updatedAt,

    this.note,
    this.recurrenceId,
  });
}
