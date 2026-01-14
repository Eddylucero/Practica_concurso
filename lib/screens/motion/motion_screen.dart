import 'package:flutter/material.dart';

import '../../models/movement_model.dart';
import '../../repositories/movement_repository.dart';

class MotionScreen extends StatefulWidget {
  const MotionScreen({super.key});

  @override
  State<MotionScreen> createState() => _MotionScreenState();
}

class _MotionScreenState extends State<MotionScreen> {
  final MovementRepository repo = MovementRepository();

  List<MovementModel> movimientos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarMovimientos();
  }

  Future<void> cargarMovimientos() async {
    setState(() => cargando = true);
    movimientos = await repo.getAll(); // listar movimientos
    setState(() => cargando = false);
  }

  void eliminarMovimiento(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Movimiento'),
        content: const Text('¿Está seguro de eliminar este movimiento?'),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarMovimientos();
            },
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  Color obtenerColor(String tipo) {
    return tipo == 'INGRESO' ? Colors.green : Colors.red;
  }

  Icon obtenerIcono(String tipo) {
    return tipo == 'INGRESO'
        ? const Icon(Icons.arrow_downward, color: Colors.green)
        : const Icon(Icons.arrow_upward, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : movimientos.isEmpty
          ? const Center(child: Text('No hay movimientos registrados'))
          : ListView.builder(
              itemCount: movimientos.length,
              itemBuilder: (context, i) {
                final mov = movimientos[i];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      leading: obtenerIcono(mov.tipo),
                      title: Text(
                        mov.descripcion,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(mov.fecha),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${mov.monto.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: obtenerColor(mov.tipo),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/movimiento/form',
                                arguments: mov,
                              );
                              cargarMovimientos();
                            },
                            icon: const Icon(Icons.edit, color: Colors.orange),
                          ),
                          IconButton(
                            onPressed: () => eliminarMovimiento(mov.id!),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/movimiento/form');
          cargarMovimientos();
        },
        backgroundColor: Colors.deepPurple,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
