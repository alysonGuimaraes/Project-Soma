import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' hide databaseFactory;
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseConnection {
  Future<Database>? _databaseFuture;

  Future<Database> get database {
    _databaseFuture ??= _initDatabase();
    return _databaseFuture!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, 'Soma', 'soma.db');

    final dbFolder = Directory(dirname(dbPath));
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      final factoryFfi = databaseFactoryFfi;

      return await factoryFfi.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
      );
    } else {
      return await openDatabase(
        dbPath,
        password: "my_password_segura",
        version: 1,
        onCreate: _onCreate,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        name TEXT NOT NULL,
        colorHex TEXT NOT NULL,
        iconCode TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS recurrences (
        id TEXT PRIMARY KEY,
        categoryId TEXT NOT NULL,
        value REAL NOT NULL,
        frequency TEXT NOT NULL,
        recurrencyInitDate TEXT NOT NULL,
        qtdOccurrence INTEGER, 
        isActive INTEGER NOT NULL, 
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS movements (
        id TEXT PRIMARY KEY,
        categoryId TEXT NOT NULL,
        recurrenceId TEXT,
        value REAL NOT NULL,
        note TEXT,
        movementDate TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories (id),
        FOREIGN KEY (recurrenceId) REFERENCES recurrences (id)
      );
    ''');
  }
}
