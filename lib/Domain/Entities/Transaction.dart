
class TransactionEntity {
  final String id;
  final double value;
  final DateTime transactionDate;
  final String monthYear;
  final String? finalMonthYear; // Define o último mês da transacao fixa
  final String categoryId;
  final String? observation;
  final bool isFixed;
  final bool isPaid;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionEntity({
    required this.id,
    required this.value,
    required this.transactionDate,
    required this.monthYear,
    this.finalMonthYear,
    required this.categoryId,
    this.observation,
    this.isFixed = false,
    this.isPaid = true,
    required this.createdAt,
    required this.updatedAt
  });
}