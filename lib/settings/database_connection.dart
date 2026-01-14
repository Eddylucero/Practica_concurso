import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  static final DatabaseConnection instance = DatabaseConnection._internal();
  factory DatabaseConnection() => instance;

  DatabaseConnection._internal();

  static Database? database;

  Future<Database> get db async {
    if (database != null) return database!;
    database = await _initDb();
    return database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'finanzas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE movimientos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT NOT NULL,
            monto REAL NOT NULL,
            fecha TEXT NOT NULL,
            descripcion TEXT
          )
        ''');
      },
    );
  }
}
