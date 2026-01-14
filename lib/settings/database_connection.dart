import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  static final DatabaseConnection instance = DatabaseConnection._internal();
  factory DatabaseConnection() => instance;

  DatabaseConnection._internal();

  static Database? database;

  // Obtener conexión
  Future<Database> get db async {
    if (database != null) return database!;
    database = await inicializarDb();
    return database!;
  }

  // Inicialización de la base de datos
  Future<Database> inicializarDb() async {
    final rutaDb = await getDatabasesPath();
    final rutaFinal = join(rutaDb, 'finanzas.db');

    return await openDatabase(
      rutaFinal,
      version: 1,
      onCreate: (Database db, int version) async {
        // Tabla Usuario
        await db.execute('''
          CREATE TABLE usuario (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            moneda TEXT
          )
        ''');

        // Tabla Movimientos
        await db.execute('''
          CREATE TABLE movimientos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT NOT NULL,       -- INGRESO o GASTO
            monto REAL NOT NULL,
            fecha TEXT NOT NULL,
            descripcion TEXT,
            usuario_id INTEGER,
            FOREIGN KEY (usuario_id) REFERENCES usuario(id)
          )
        ''');
      },
    );
  }
}
