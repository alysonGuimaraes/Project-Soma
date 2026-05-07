class NewTransactionValidator {
  static String? validate({
    required double value,
    required String categoryId,
    required DateTime transactionDate,
    required bool isFixed,
    String? finalMonthYear,
  }) {
    if (value <= 0) {
      return 'O valor da transação deve ser maior que zero';
    }

    if (categoryId.isEmpty) {
      return 'Selecione uma categoria';
    }

    if (transactionDate.isAfter(
      DateTime.now().add(const Duration(days: 365)),
    )) {
      return 'A data não pode ser superior a 1 ano no futuro';
    }

    if (isFixed && finalMonthYear != null && finalMonthYear.isEmpty) {
      return 'Informe o mês final ou marque como indeterminado';
    }

    return null;
  }
}
