class TransactionEntity {
  final int? id;
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
    this.id,
    required this.value,
    required this.transactionDate,
    required this.monthYear,
    this.finalMonthYear,
    required this.categoryId,
    this.observation,
    this.isFixed = false,
    this.isPaid = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionEntity.create({
    required double value,
    required String categoryId,
    required DateTime transactionDate,
    required bool isFixed,
    required bool isPaid,
    String? observation,
    String? finalMonthYear,
  }) {
    final now = DateTime.now();
    return TransactionEntity(
      id: null,
      value: value,
      monthYear:
          "${transactionDate.month.toString().padLeft(2, '0')}${transactionDate.year}",
      categoryId: categoryId,
      transactionDate: transactionDate,
      isFixed: isFixed,
      isPaid: isPaid,
      observation: observation,
      finalMonthYear: finalMonthYear,
      createdAt: now,
      updatedAt: now,
    );
  }
}
