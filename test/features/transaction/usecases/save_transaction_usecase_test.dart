import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_soma/features/transaction/domain/entities/transaction.dart';
import 'package:project_soma/features/transaction/domain/usecases/save_transaction_usecase.dart';

import '../mocks/transaction_mocks.mocks.dart';

void main() {
  late SaveTransactionUseCase useCase;
  late MockITransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockITransactionRepository();
    useCase = SaveTransactionUseCase(mockRepository);
  });

  group('SaveTransactionUseCase', () {
    final transactionDate = DateTime(2025, 4, 1);

    test('deve chamar createTransaction com os dados corretos', () async {
      when(mockRepository.createTransaction(any)).thenAnswer((_) async {});

      await useCase.call(
        value: 100.0,
        categoryId: 'cat_01',
        transactionDate: transactionDate,
        isFixed: false,
        isPaid: true,
      );

      verify(mockRepository.createTransaction(any)).called(1);
    });

    test('deve criar transação com monthYear correto', () async {
      TransactionEntity? captured;

      when(mockRepository.createTransaction(any)).thenAnswer((
        invocation,
      ) async {
        captured = invocation.positionalArguments[0] as TransactionEntity;
      });

      await useCase.call(
        value: 100.0,
        categoryId: 'cat_01',
        transactionDate: transactionDate,
        isFixed: false,
        isPaid: true,
      );

      expect(captured?.monthYear, '042025');
    });

    test(
      'deve criar transação com observation nula quando não informada',
      () async {
        TransactionEntity? captured;

        when(mockRepository.createTransaction(any)).thenAnswer((
          invocation,
        ) async {
          captured = invocation.positionalArguments[0] as TransactionEntity;
        });

        await useCase.call(
          value: 100.0,
          categoryId: 'cat_01',
          transactionDate: transactionDate,
          isFixed: false,
          isPaid: true,
        );

        expect(captured?.observation, isNull);
      },
    );

    test(
      'deve criar transação com finalMonthYear nulo quando não for fixa',
      () async {
        TransactionEntity? captured;

        when(mockRepository.createTransaction(any)).thenAnswer((
          invocation,
        ) async {
          captured = invocation.positionalArguments[0] as TransactionEntity;
        });

        await useCase.call(
          value: 100.0,
          categoryId: 'cat_01',
          transactionDate: transactionDate,
          isFixed: false,
          isPaid: true,
        );

        expect(captured?.finalMonthYear, isNull);
      },
    );

    test('deve lançar exception quando repositório falhar', () async {
      when(
        mockRepository.createTransaction(any),
      ).thenThrow(Exception('Erro no banco'));

      expect(
        () => useCase.call(
          value: 100.0,
          categoryId: 'cat_01',
          transactionDate: transactionDate,
          isFixed: false,
          isPaid: true,
        ),
        throwsException,
      );
    });
  });
}
