import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  // Padrão Singleton: Garante apenas uma instância da conexão
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  // Retorna o banco, ou inicializa se for a primeira vez
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // 1. Inicializa o FFI (Obrigatório para Desktop)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // 2. Define onde o banco será salvo (ex: Documentos/Soma/soma.db)
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, 'Soma', 'soma.db');

    // Cria a pasta "Soma" caso ela não exista
    final dbFolder = Directory(dirname(dbPath));
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    // 3. Abre a conexão e cria as tabelas se for a primeira vez
    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
  }

  // Script DDL de criação das tabelas
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Categories (
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
      CREATE TABLE IF NOT EXISTS Transactions (
          id TEXT PRIMARY KEY,
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