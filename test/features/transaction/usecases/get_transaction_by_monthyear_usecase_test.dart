import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_soma/features/transaction/domain/entities/transaction.dart';
import 'package:project_soma/features/transaction/domain/usecases/get_transaction_by_monthyear_usecase.dart';

import '../mocks/transaction_mocks.mocks.dart';

void main() {
  late GetTransactionsByMonthUseCase useCase;
  late MockITransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockITransactionRepository();
    useCase = GetTransactionsByMonthUseCase(mockRepository);
  });

  List<TransactionEntity> makeTransactions(int count) {
    return List.generate(
      count,
      (i) => TransactionEntity(
        id: i + 1,
        value: 100.0 * (i + 1),
        monthYear: '042025',
        categoryId: 'cat_01',
        transactionDate: DateTime(2025, 4, i + 1),
        isFixed: false,
        isPaid: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  group('GetTransactionsByMonthUseCase', () {
    test('deve retornar lista de transações do mês informado', () async {
      final transactions = makeTransactions(3);

      when(
        mockRepository.getTransactionsByMonthYear('042025'),
      ).thenAnswer((_) async => transactions);

      final result = await useCase.call('042025');

      expect(result, equals(transactions));
      expect(result?.length, 3);
    });

    test('deve retornar lista vazia quando não houver transações', () async {
      when(
        mockRepository.getTransactionsByMonthYear('042025'),
      ).thenAnswer((_) async => []);

      final result = await useCase.call('042025');

      expect(result, isEmpty);
    });

    test('deve chamar o repositório com o monthYear correto', () async {
      when(
        mockRepository.getTransactionsByMonthYear('032025'),
      ).thenAnswer((_) async => []);

      await useCase.call('032025');

      verify(mockRepository.getTransactionsByMonthYear('032025')).called(1);
    });

    test(
      'não deve chamar o repositório com monthYear diferente do informado',
      () async {
        when(
          mockRepository.getTransactionsByMonthYear('042025'),
        ).thenAnswer((_) async => []);

        await useCase.call('042025');

        verifyNever(mockRepository.getTransactionsByMonthYear('032025'));
      },
    );

    test('deve lançar exception quando repositório falhar', () async {
      when(
        mockRepository.getTransactionsByMonthYear(any),
      ).thenThrow(Exception('Erro no banco'));

      expect(() => useCase.call('042025'), throwsException);
    });
  });
}
