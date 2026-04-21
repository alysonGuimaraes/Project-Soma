import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:project_soma/features/transaction/domain/entities/transaction.dart';
import 'package:project_soma/features/transaction/domain/entities/transaction_filter.dart';
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
              id INTEGER PRIMARY KEY AUTOINCREMENT,
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
              FOREIGN KEY (categoryId) REFERENCES Categories(id) ON DELETE RESTRICT
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

  tearDown(() async => await db.close());

  group('TransactionRepositoryImpl |', () {
    final tDate = DateTime(2026, 3, 24);

    // ✅ Sem id — banco gera via autoincrement
    final tTransaction = TransactionEntity.create(
      value: 150.50,
      categoryId: 'cat_1',
      transactionDate: tDate,
      observation: 'Compra teste',
      isFixed: false,
      isPaid: true,
    );

    final tx1 = TransactionEntity.create(
      value: 50.0,
      categoryId: 'cat_1',
      transactionDate: DateTime(2026, 2, 10),
      isFixed: false,
      isPaid: true,
    );

    final tx2 = TransactionEntity.create(
      value: 150.0,
      categoryId: 'cat_1',
      transactionDate: DateTime(2026, 3, 15),
      isFixed: true,
      isPaid: false,
    );

    final tx3 = TransactionEntity.create(
      value: 300.0,
      categoryId: 'cat_1',
      transactionDate: DateTime(2026, 3, 25),
      isFixed: true,
      isPaid: true,
    );

    test('Deve inserir uma transação e buscar pelo ID com sucesso', () async {
      await repository.createTransaction(tTransaction);

      // Busca pelo id gerado pelo banco após inserção
      final maps = await db.query('transactions', limit: 1);
      final insertedId = maps.first['id'] as int;

      final result = await repository.getTransactionById(insertedId);

      expect(result, isNotNull);
      expect(result!.id, insertedId); // ← int gerado pelo banco
      expect(result.value, 150.50);
      expect(result.monthYear, '032026'); // ← formato correto
      expect(result.isPaid, isTrue);
    });

    test('Deve atualizar os dados de uma transação existente', () async {
      await repository.createTransaction(tTransaction);

      final maps = await db.query('transactions', limit: 1);
      final insertedId = maps.first['id'] as int;

      final updatedTransaction = TransactionEntity(
        id: insertedId,
        value: 300.00,
        transactionDate: tDate,
        monthYear: '032026',
        categoryId: 'cat_1',
        observation: 'Compra editada',
        isFixed: false,
        isPaid: false,
        createdAt: tDate,
        updatedAt: DateTime.now(),
      );

      await repository.updateTransaction(updatedTransaction);
      final result = await repository.getTransactionById(insertedId);

      expect(result!.value, 300.00);
      expect(result.isPaid, isFalse);
      expect(result.observation, 'Compra editada');
    });

    test('Deve deletar uma transação do banco', () async {
      await repository.createTransaction(tTransaction);

      final maps = await db.query('transactions', limit: 1);
      final insertedId = maps.first['id'] as int;

      await repository.deleteTransaction(insertedId);
      final result = await repository.getTransactionById(insertedId);

      expect(result, isNull);
    });

    test(
      'getTransactionsByMonthYear | Deve retornar transações do mês solicitado',
      () async {
        await repository.createTransaction(tx1); // monthYear: 022026
        await repository.createTransaction(tx2); // monthYear: 032026
        await repository.createTransaction(tx3); // monthYear: 032026

        final result = await repository.getTransactionsByMonthYear('032026');

        expect(
          result.length,
          2,
          reason: 'Deveria encontrar exatamente 2 transações de março',
        );
      },
    );

    test(
      'getTransactionsByMonthYear | Deve retornar lista vazia se não houver transações',
      () async {
        await repository.createTransaction(tx1);

        final result = await repository.getTransactionsByMonthYear('122026');

        expect(result, isEmpty);
      },
    );

    test(
      'getTransactionsByFilter | Deve retornar todas as transações se o filtro for vazio',
      () async {
        await repository.createTransaction(tx1);
        await repository.createTransaction(tx2);

        final result = await repository.getTransactionsByFilter(
          TransactionFilter(),
        );

        expect(result?.length, 2);
      },
    );

    test('getTransactionsByFilter | Deve filtrar por range de valor', () async {
      await repository.createTransaction(tx1);
      await repository.createTransaction(tx2);
      await repository.createTransaction(tx3);

      final result = await repository.getTransactionsByFilter(
        TransactionFilter(minValue: 100.0, maxValue: 200.0),
      );

      expect(result?.length, 1);
      expect(result?.first.value, 150.0);
    });

    test(
      'getTransactionsByFilter | Deve filtrar por isFixed e isPaid',
      () async {
        await repository.createTransaction(tx1);
        await repository.createTransaction(tx2);
        await repository.createTransaction(tx3);

        final result = await repository.getTransactionsByFilter(
          TransactionFilter(isFixed: true, isPaid: false),
        );

        expect(result?.length, 1);
        expect(result?.first.value, 150.0);
      },
    );

    test(
      'getTransactionsByFilter | Deve filtrar por período de datas',
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

        expect(result?.length, 1);
        expect(result?.first.value, 150.0);
      },
    );
  });
}
