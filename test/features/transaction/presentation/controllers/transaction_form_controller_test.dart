import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_soma/features/transaction/presentation/controllers/transaction_form_controller.dart';

import '../../mocks/transaction_mocks.mocks.dart';

void main() {
  late MockSaveTransactionUseCase mockSaveUseCase;
  late TransactionFormController controller;

  setUp(() {
    mockSaveUseCase = MockSaveTransactionUseCase();
    controller = TransactionFormController(save: mockSaveUseCase);
  });

  group('TransactionFormController |', () {
    final dummyDate = DateTime(2025, 12, 20);

    test('Deve iniciar com o estado padrão correto', () {
      expect(controller.isSubmitting, isFalse);
      expect(controller.error, isNull);
      expect(controller.success, isFalse);
    });

    test('Deve atualizar os estados e chamar o usecase com sucesso', () async {
      when(
        mockSaveUseCase.call(
          value: anyNamed('value'),
          categoryId: anyNamed('categoryId'),
          transactionDate: anyNamed('transactionDate'),
          isFixed: anyNamed('isFixed'),
          isPaid: anyNamed('isPaid'),
          observation: anyNamed('observation'),
          finalMonthYear: anyNamed('finalMonthYear'),
        ),
      ).thenAnswer((_) async {});

      final future = controller.save(
        value: 150.0,
        categoryId: 'cat_01',
        transactionDate: dummyDate,
        isFixed: false,
        isPaid: true,
        observation: 'Teste de sucesso',
      );

      expect(controller.isSubmitting, isTrue);

      await future;

      expect(controller.success, isTrue);
      expect(controller.error, isNull);
      expect(controller.isSubmitting, isFalse);

      verify(
        mockSaveUseCase.call(
          value: 150.0,
          categoryId: 'cat_01',
          transactionDate: dummyDate,
          isFixed: false,
          isPaid: true,
          observation: 'Teste de sucesso',
          finalMonthYear: null,
        ),
      ).called(1);
    });

    test(
      'Deve popular a variável error se o usecase lançar uma exceção',
      () async {
        // Arrange
        when(
          mockSaveUseCase.call(
            value: anyNamed('value'),
            categoryId: anyNamed('categoryId'),
            transactionDate: anyNamed('transactionDate'),
            isFixed: anyNamed('isFixed'),
            isPaid: anyNamed('isPaid'),
            observation: anyNamed('observation'),
            finalMonthYear: anyNamed('finalMonthYear'),
          ),
        ).thenThrow(Exception('Simulando um erro no banco de dados'));

        await controller.save(
          value: 150.0,
          categoryId: 'cat_01',
          transactionDate: dummyDate,
          isFixed: false,
          isPaid: true,
        );

        expect(controller.success, isFalse);
        expect(controller.error, 'Erro ao salvar transação');
        expect(controller.isSubmitting, isFalse);
      },
    );
  });
}
