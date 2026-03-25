
enum TransactionType { income, expense }

class CategoryEntity {
  final String id;
  final String description;
  final TransactionType type;
  final String? colorHex;
  final String? iconCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryEntity({
    required this.id,
    required this.description,
    required this.type,
    this.colorHex,
    this.iconCode,
    required this.createdAt,
    required this.updatedAt,
  });
}