class MovementModel {
  int? id;
  String tipo; // INGRESO o GASTO
  double monto;
  String fecha; // YYYY-MM-DD
  String descripcion;

  // Constructor
  MovementModel({
    this.id,
    required this.tipo,
    required this.monto,
    required this.fecha,
    required this.descripcion,
  });

  // Convertir de Map a Clase (SELECT)
  factory MovementModel.fromMap(Map<String, dynamic> data) {
    return MovementModel(
      id: data['id'],
      tipo: data['tipo'],
      monto: data['monto'],
      fecha: data['fecha'],
      descripcion: data['descripcion'],
    );
  }

  // Convertir de Clase a Map (INSERT, UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'monto': monto,
      'fecha': fecha,
      'descripcion': descripcion,
    };
  }
}
