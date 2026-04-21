
class TransactionFilter {
  final double? minValue;
  final double? maxValue;
  final String? monthYear;
  final String? categoryId;
  final bool? isFixed;
  final bool? isPaid;
  final DateTime? startDate;
  final DateTime? endDate;

  TransactionFilter({
    this.minValue,
    this.maxValue,
    this.monthYear,
    this.categoryId,
    this.isFixed,
    this.isPaid,
    this.startDate,
    this.endDate,
  });
}