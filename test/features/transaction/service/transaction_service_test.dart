import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_soma/features/transaction/domain/entities/transaction.dart';
import 'package:project_soma/features/transaction/domain/entities/transaction_filter.dart';
import 'package:project_soma/features/transaction/domain/repository/i_transaction_repository.dart';
import 'package:project_soma/features/transaction/service/transaction_service.dart';

class MockTransactionRepository extends Mock
    implements ITransactionRepository {}

class FakeTransactionEntity extends Fake implements TransactionEntity {}

void main() {
  late TransactionService controller;
  late MockTransactionRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeTransactionEntity());
  });

  setUp(() {
    mockRepository = MockTransactionRepository();
    controller = TransactionService(mockRepository);
  });

  group('TransactionController |', () {
    final tDate = DateTime.now();
    final expectedMonthYear =
        "${tDate.month.toString().padLeft(2, '0')}${tDate.year}";

    test(
      'Deve chamar createTransaction no repositorio ao salvar uma nova transaçao',
      () async {
        when(
          () => mockRepository.createTransaction(any()),
        ).thenAnswer((_) async {});

        await controller.saveNewTransaction(
          value: 150.0,
          categoryId: 'cat_1',
          transactionDate: tDate,
          observation: 'Teste de captura',
          isFixed: false,
          isPaid: true,
          finalMonthYear: '122026',
        );

        // verify(() => mockRepository.createTransaction(any())).called(1);

        final captured = verify(
          () => mockRepository.createTransaction(captureAny()),
        ).captured;
        final savedEntity = captured.first as TransactionEntity;

        expect(savedEntity.value, 150.0);
        expect(savedEntity.categoryId, 'cat_1');
        expect(savedEntity.observation, 'Teste de captura');
        expect(savedEntity.transactionDate, tDate);
        expect(savedEntity.isFixed, isFalse);
        expect(savedEntity.isPaid, isTrue);
        expect(savedEntity.finalMonthYear, '122026');

        expect(savedEntity.id, isNotEmpty);
        expect(savedEntity.monthYear, expectedMonthYear);
        expect(savedEntity.createdAt, isA<DateTime>());
        expect(savedEntity.updatedAt, isA<DateTime>());
      },
    );

    test(
      'Deve chamar deleteTransaction no repositorio com o ID correto',
      () async {
        when(
          () => mockRepository.deleteTransaction('id_123'),
        ).thenAnswer((_) async {});

        await controller.deleteTransaction('id_123');

        verify(() => mockRepository.deleteTransaction('id_123')).called(1);
      },
    );

    test(
      'Deve atualizar uma transacao preservando o ID e a data de criacao original',
      () async {
        final tDate = DateTime.now();
        final oldDate = DateTime(2025, 1, 1);
        final expectedMonthYear =
            "${tDate.month.toString().padLeft(2, '0')}${tDate.year}";

        final oldTransaction = TransactionEntity(
          id: 'id_123',
          value: 50.0,
          transactionDate: oldDate,
          monthYear: '012025',
          categoryId: 'cat_old',
          isFixed: true,
          isPaid: true,
          createdAt: oldDate,
          updatedAt: oldDate,
        );

        final newTransactionData = TransactionEntity(
          id: 'id_errado',
          value: 200.0,
          transactionDate: tDate,
          monthYear: expectedMonthYear,
          categoryId: 'cat_new',
          observation: 'Atualização confirmada',
          isFixed: false,
          isPaid: false,
          finalMonthYear: '122026',
          createdAt: tDate,
          updatedAt: tDate,
        );

        when(
          () => mockRepository.getTransactionById('id_123'),
        ).thenAnswer((_) async => oldTransaction);
        when(
          () => mockRepository.updateTransaction(any()),
        ).thenAnswer((_) async {});

        await controller.updateTransaction(
          oldTransaction.id,
          newTransactionData,
        );

        final captured = verify(
          () => mockRepository.updateTransaction(captureAny()),
        ).captured;
        final updatedEntity = captured.first as TransactionEntity;

        expect(updatedEntity.value, 200.0);
        expect(updatedEntity.categoryId, 'cat_new');
        expect(updatedEntity.observation, 'Atualização confirmada');
        expect(updatedEntity.isFixed, isFalse);
        expect(updatedEntity.isPaid, isFalse);
        expect(updatedEntity.finalMonthYear, '122026');

        expect(
          updatedEntity.id,
          'id_123',
          reason: 'O ID não pode ser alterado',
        );
        expect(
          updatedEntity.createdAt,
          oldDate,
          reason: 'A data de criação original deve ser preservada',
        );
        expect(
          updatedEntity.updatedAt.isAfter(oldDate),
          isTrue,
          reason: 'A data de atualização deve ser recente',
        );
        expect(
          updatedEntity.monthYear,
          expectedMonthYear,
          reason: 'O mês/ano deve ser no formato MMYYYY',
        );
      },
    );

    test(
      'Deve lancar Exception ao tentar atualizar uma transacao inexistente',
      () async {
        when(
          () => mockRepository.getTransactionById('id_falso'),
        ).thenAnswer((_) async => null);

        final newTransactionData = FakeTransactionEntity();

        final call = controller.updateTransaction(
          'id_falso',
          newTransactionData,
        );

        expect(() => call, throwsA(isA<Exception>()));

        verifyNever(() => mockRepository.updateTransaction(any()));
      },
    );

    test(
      'Deve retornar uma lista de transacoes ao buscar por Mes/Ano',
      () async {
        final dummyList = [FakeTransactionEntity(), FakeTransactionEntity()];
        when(
          () => mockRepository.getTransactionsByMonthYear('032026'),
        ).thenAnswer((_) async => dummyList);

        final result = await controller.getTransactionsByMonthYear('032026');

        expect(result, isNotNull);
        expect(result!.length, 2);
        verify(
          () => mockRepository.getTransactionsByMonthYear('032026'),
        ).called(1);
      },
    );

    test(
      'Deve retornar uma lista de transacoes ao buscar por Filtro',
      () async {
        final dummyList = [FakeTransactionEntity()];
        final filter = TransactionFilter(isFixed: true);

        when(
          () => mockRepository.getTransactionsByFilter(filter),
        ).thenAnswer((_) async => dummyList);

        final result = await controller.getTransactionsByFilter(filter);

        expect(result, isNotNull);
        expect(result!.length, 1);
        verify(() => mockRepository.getTransactionsByFilter(filter)).called(1);
      },
    );

    test('Deve retornar uma transacao especifica ao buscar pelo ID', () async {
      final tDate = DateTime.now();
      final dummyTransaction = TransactionEntity(
        id: 'id_123',
        value: 50.0,
        transactionDate: tDate,
        monthYear: '032026',
        categoryId: 'cat_1',
        isFixed: false,
        isPaid: true,
        createdAt: tDate,
        updatedAt: tDate,
      );

      when(
        () => mockRepository.getTransactionById('id_123'),
      ).thenAnswer((_) async => dummyTransaction);

      final result = await controller.getTransactionById('id_123');

      expect(result, isNotNull);
      expect(result!.id, 'id_123');
      verify(() => mockRepository.getTransactionById('id_123')).called(1);
    });
  });
}
