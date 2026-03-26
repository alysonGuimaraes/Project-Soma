import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/data/repositories/transaction_repository_impl.dart';
import 'package:project_soma/domain/entities/transaction.dart';
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
  });
}
