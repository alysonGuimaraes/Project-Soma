import 'package:flutter/services.dart';

class MonetaryFormatter extends TextInputFormatter {
  final String symbol;
  final String thousandSeparator;
  final String decimalSeparator;
  final int decimalDigits;

  // Construtor flexível com pt_BR como padrão
  MonetaryFormatter({
    this.symbol = 'R\$ ',
    this.thousandSeparator = '.',
    this.decimalSeparator = ',',
    this.decimalDigits = 2,
  });

  // Fábrica para criar o formatador em Inglês (en_US) facilmente
  factory MonetaryFormatter.enUS() {
    return MonetaryFormatter(
      symbol: '\$ ',
      thousandSeparator: ',',
      decimalSeparator: '.',
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');

    String numbersOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbersOnly.isEmpty) return newValue.copyWith(text: '');

    numbersOnly = numbersOnly.replaceFirst(RegExp(r'^0+'), '');

    if (numbersOnly.length < decimalDigits + 1) {
      numbersOnly = numbersOnly.padLeft(decimalDigits + 1, '0');
    }

    final decimals = numbersOnly.substring(numbersOnly.length - decimalDigits);
    final integers = numbersOnly.substring(
      0,
      numbersOnly.length - decimalDigits,
    );

    final formattedIntegers = StringBuffer();
    int count = 0;

    for (int i = integers.length - 1; i >= 0; i--) {
      formattedIntegers.write(integers[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        formattedIntegers.write(thousandSeparator);
      }
    }

    final reversedIntegers = formattedIntegers
        .toString()
        .split('')
        .reversed
        .join();

    final newText = '$symbol$reversedIntegers$decimalSeparator$decimals';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
