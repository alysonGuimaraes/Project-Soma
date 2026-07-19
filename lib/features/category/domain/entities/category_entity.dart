enum TransactionType { income, expense }

class CategoryEntity {
  final String id;
  final TransactionType type;
  final String name;
  final String? colorHex;
  final String? iconCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryEntity({
    required this.id,
    required this.type,
    required this.name,
    this.colorHex,
    this.iconCode,
    required this.createdAt,
    required this.updatedAt,
  });
}
