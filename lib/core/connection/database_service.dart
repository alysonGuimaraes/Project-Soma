import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  Future<Database>? _databaseFuture;

  Future<Database> get database {
    _databaseFuture ??= _initDatabase();
    return _databaseFuture!;
  }

  Future<Database> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, 'Soma', 'soma.db');

    final dbFolder = Directory(dirname(dbPath));
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    // 3. Abre a conexão e cria as tabelas se for a primeira vez
    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          description TEXT NOT NULL,
          type TEXT NOT NULL,
          colorHex TEXT,
          iconCode TEXT,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          value REAL NOT NULL,
          transactionDate TEXT NOT NULL,
          monthYear TEXT NOT NULL,
          finalMonthYear TEXT,
          categoryId TEXT NOT NULL,
          observation TEXT,
          isFixed INTEGER NOT NULL DEFAULT 0,
          isPaid INTEGER NOT NULL DEFAULT 1,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          FOREIGN KEY (categoryId) REFERENCES Categories (id) ON DELETE RESTRICT
      )
    ''');
  }
}
