import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/data/repositories/transaction_repository_impl.dart';
import 'package:project_soma/domain/entities/transaction.dart';
import 'package:project_soma/domain/entities/transaction_filter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late TransactionRepositoryImpl repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE Categories (
                id TEXT PRIMARY KEY,
                description TEXT NOT NULL,
                type TEXT NOT NULL,
                colorHex TEXT,
                iconCode TEXT,
                createdAt TEXT NOT NULL,
                updatedAt TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE transactions (
                id TEXT PRIMARY KEY,
                value REAL NOT NULL,
                transactionDate TEXT NOT NULL,
                monthYear TEXT NOT NULL,
                categoryId TEXT NOT NULL,
                observation TEXT,
                isFixed INTEGER NOT NULL DEFAULT 0,
                isPaid INTEGER NOT NULL DEFAULT 1,
                finalMonthYear TEXT,
                createdAt TEXT NOT NULL,
                updatedAt TEXT NOT NULL,
                FOREIGN KEY (categoryId) REFERENCES Categories (id) ON DELETE RESTRICT
            )
          ''');
        },
      ),
    );

    await db.insert('Categories', {
      'id': 'cat_1',
      'description': 'Categoria Teste',
      'type': 'expense',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    repository = TransactionRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TransactionRepositoryImpl |', () {
    final tDate = DateTime(2026, 3, 24);

    final tTransaction = TransactionEntity(
      id: 'trans_123',
      value: 150.50,
      transactionDate: tDate,
      monthYear: '03/2026',
      categoryId: 'cat_1',
      observation: 'Compra teste',
      isFixed: false,
      isPaid: true,
      createdAt: tDate,
      updatedAt: tDate,
    );

    final tx1 = TransactionEntity(
      id: 'tx_1',
      value: 50.0,
      transactionDate: DateTime(2026, 2, 10),
      monthYear: '022026',
      categoryId: 'cat_1',
      isFixed: false,
      isPaid: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final tx2 = TransactionEntity(
      id: 'tx_2',
      value: 150.0,
      transactionDate: DateTime(2026, 3, 15),
      monthYear: '032026',
      categoryId: 'cat_1',
      isFixed: true,
      isPaid: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final tx3 = TransactionEntity(
      id: 'tx_3',
      value: 300.0,
      transactionDate: DateTime(2026, 3, 25),
      monthYear: '032026',
      categoryId: 'cat_1',
      isFixed: true,
      isPaid: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('Deve inserir uma transação e buscar pelo ID com sucesso', () async {
      await repository.createTransaction(tTransaction);

      final result = await repository.getTransactionById('trans_123');

      expect(result, isNotNull);
      expect(result!.id, 'trans_123');
      expect(result.value, 150.50);
      expect(result.monthYear, '03/2026');
      expect(result.isPaid, isTrue);
    });

    test('Deve atualizar os dados de uma transação existente', () async {
      await repository.createTransaction(tTransaction);

      final updatedTransaction = TransactionEntity(
        id: 'trans_123',
        value: 300.00,
        transactionDate: tDate,
        monthYear: '03/2026',
        categoryId: 'cat_1',
        observation: 'Compra editada',
        isFixed: false,
        isPaid: false,
        createdAt: tDate,
        updatedAt: DateTime.now(),
      );

      await repository.updateTransaction(updatedTransaction);
      final result = await repository.getTransactionById('trans_123');

      expect(result!.value, 300.00);
      expect(result.isPaid, isFalse);
      expect(result.observation, 'Compra editada');
    });

    test('Deve deletar uma transação do banco', () async {
      await repository.createTransaction(tTransaction);

      await repository.deleteTransaction('trans_123');
      final result = await repository.getTransactionById('trans_123');

      expect(result, isNull);
    });

    test(
      'getTransactionsByMonthYear | Deve retornar apenas as transacoes do mes solicitado',
      () async {
        await repository.createTransaction(tx1);
        await repository.createTransaction(tx2);
        await repository.createTransaction(tx3);

        final result = await repository.getTransactionsByMonthYear('032026');

        expect(result, isNotNull);
        expect(
          result!.length,
          2,
          reason: 'Deveria encontrar exatamente 2 transações de março',
        );
        expect(result[1].id, 'tx_3');
        expect(result[0].id, 'tx_2');
      },
    );

    test(
      'getTransactionsByMonthYear | Deve retornar NULL se nao houver transacoes no mes',
      () async {
        await repository.createTransaction(tx1);

        final result = await repository.getTransactionsByMonthYear('122026');

        expect(
          result,
          isNull,
          reason: 'O método deve retornar null se a lista for vazia',
        );
      },
    );

    test(
      'getTransactionsByFilter | Deve retornar todas as transacoes se o filtro for vazio',
      () async {
        await repository.createTransaction(tx1);
        await repository.createTransaction(tx2);

        final result = await repository.getTransactionsByFilter(
          TransactionFilter(),
        );

        expect(result, isNotNull);
        expect(result!.length, 2);
      },
    );

    test(
      'getTransactionsByFilter | Deve filtrar corretamente por range de valor (min e max)',
      () async {
        await repository.createTransaction(tx1);
        await repository.createTransaction(tx2);
        await repository.createTransaction(tx3);

        final result = await repository.getTransactionsByFilter(
          TransactionFilter(minValue: 100.0, maxValue: 200.0),
        );

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result.first.id, 'tx_2');
      },
    );

    test(
      'getTransactionsByFilter | Deve filtrar combinando isFixed e isPaid',
      () async {
        await repository.createTransaction(tx1);
        await repository.createTransaction(tx2);
        await repository.createTransaction(tx3);

        final result = await repository.getTransactionsByFilter(
          TransactionFilter(isFixed: true, isPaid: false),
        );

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result.first.id, 'tx_2');
      },
    );

    test(
      'getTransactionsByFilter | Deve filtrar por periodo de datas (startDate e endDate)',
      () async {
        await repository.createTransaction(tx1);
        await repository.createTransaction(tx2);
        await repository.createTransaction(tx3);

        final result = await repository.getTransactionsByFilter(
          TransactionFilter(
            startDate: DateTime(2026, 3, 1),
            endDate: DateTime(2026, 3, 20),
          ),
        );

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result.first.id, 'tx_2');
      },
    );
  });
}
