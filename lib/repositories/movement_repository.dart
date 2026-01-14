import '../models/movement_model.dart';
import '../settings/database_connection.dart';

class MovementRepository {
  final tableName = 'movimientos';
  final database = DatabaseConnection();

  // Insertar movimiento
  Future<int> create(MovementModel data) async {
    final db = await database.db;
    return await db.insert(tableName, data.toMap());
  }

  // Editar movimiento
  Future<int> edit(MovementModel data) async {
    final db = await database.db;
    return await db.update(
      tableName,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // Eliminar movimiento
  Future<int> delete(int id) async {
    final db = await database.db;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Listar todos los movimientos
  Future<List<MovementModel>> getAll() async {
    final db = await database.db;
    final response = await db.query(tableName, orderBy: 'fecha DESC');

    return response.map((e) => MovementModel.fromMap(e)).toList();
  }

  // Listar solo ingresos
  Future<List<MovementModel>> getIngresos() async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'tipo = ?',
      whereArgs: ['INGRESO'],
      orderBy: 'fecha DESC',
    );

    return response.map((e) => MovementModel.fromMap(e)).toList();
  }

  // Listar solo gastos
  Future<List<MovementModel>> getGastos() async {
    final db = await database.db;
    final response = await db.query(
      tableName,
      where: 'tipo = ?',
      whereArgs: ['GASTO'],
      orderBy: 'fecha DESC',
    );

    return response.map((e) => MovementModel.fromMap(e)).toList();
  }

  // Total de ingresos
  Future<double> getTotalIngresos() async {
    final db = await database.db;
    final result = await db.rawQuery(
      "SELECT SUM(monto) as total FROM $tableName WHERE tipo = 'INGRESO'",
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Total de gastos
  Future<double> getTotalGastos() async {
    final db = await database.db;
    final result = await db.rawQuery(
      "SELECT SUM(monto) as total FROM $tableName WHERE tipo = 'GASTO'",
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
