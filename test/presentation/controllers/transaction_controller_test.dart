
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_soma/Domain/Entities/transaction.dart';
import 'package:project_soma/Domain/Repositories/i_transaction_repository.dart';
import 'package:project_soma/Presentation/Controllers/transaction_controller.dart';


class MockTransactionRepository extends Mock implements ITransactionRepository {}

class FakeTransactionEntity extends Fake implements TransactionEntity {}

void main() {
  late TransactionController controller;
  late MockTransactionRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeTransactionEntity());
  });

  setUp(() {
    mockRepository = MockTransactionRepository();
    controller = TransactionController(mockRepository);
  });

  group('TransactionController |', () {
    final tDate = DateTime(2026, 3, 24);

    test('Deve chamar createTransaction no repositório ao salvar uma nova transação', () async {
      when(() => mockRepository.createTransaction(any())).thenAnswer((_) async {});

      await controller.saveNewTransaction(
        value: 150.0,
        categoryId: 'cat_1',
        transactionDate: tDate,
        isFixed: false,
        isPaid: true,
      );

      verify(() => mockRepository.createTransaction(any())).called(1);
    });

    test('Deve lançar Exception ao tentar atualizar uma transação que não existe', () async {
      when(() => mockRepository.getTransactionById('123')).thenAnswer((_) async => null);

      final call = controller.updateTransaction(
        id: '123',
        value: 200.0,
        categoryId: 'cat_1',
        transactionDate: tDate,
        isFixed: false,
        isPaid: true,
      );

      expect(() => call, throwsA(isA<Exception>()));
    });

    test('Deve deletar uma transação com sucesso', () async {
      when(() => mockRepository.deleteTransaction('123')).thenAnswer((_) async {});

      await controller.deleteTransaction('123');

      verify(() => mockRepository.deleteTransaction('123')).called(1);
    });
  });
}