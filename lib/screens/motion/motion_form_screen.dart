import 'package:flutter/material.dart';

import '../../models/movement_model.dart';
import '../../repositories/movement_repository.dart';

class MotionFormScreen extends StatefulWidget {
  const MotionFormScreen({super.key});

  @override
  State<MotionFormScreen> createState() => _MotionFormScreenState();
}

class _MotionFormScreenState extends State<MotionFormScreen> {
  final formMovement = GlobalKey<FormState>();

  final montoController = TextEditingController();
  final fechaController = TextEditingController();
  final descripcionController = TextEditingController();

  String tipoSeleccionado = 'INGRESO';
  MovementModel? movimiento;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      movimiento = args as MovementModel;
      tipoSeleccionado = movimiento!.tipo;
      montoController.text = movimiento!.monto.toString();
      fechaController.text = movimiento!.fecha;
      descripcionController.text = movimiento!.descripcion;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = movimiento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Movimiento' : 'Registrar Movimiento'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formMovement,
          child: Column(
            children: [
              const SizedBox(height: 15),

              // Tipo (INGRESO / GASTO)
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Tipo de Movimiento',
                  prefixIcon: const Icon(Icons.swap_vert),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'INGRESO', child: Text('Ingreso')),
                  DropdownMenuItem(value: 'GASTO', child: Text('Gasto')),
                ],
                onChanged: (value) {
                  setState(() {
                    tipoSeleccionado = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              // Monto
              TextFormField(
                controller: montoController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El monto es requerido';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un valor válido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Monto',
                  hintText: 'Ingrese el monto',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Fecha
              TextFormField(
                controller: fechaController,
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La fecha es requerida';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final fecha = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (fecha != null) {
                    fechaController.text = fecha.toIso8601String().substring(
                      0,
                      10,
                    );
                  }
                },
              ),

              const SizedBox(height: 15),

              // Descripción
              TextFormField(
                controller: descripcionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Detalle del movimiento',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if (formMovement.currentState!.validate()) {
                            final repo = MovementRepository();

                            final movement = MovementModel(
                              tipo: tipoSeleccionado,
                              monto: double.parse(montoController.text),
                              fecha: fechaController.text,
                              descripcion: descripcionController.text,
                            );

                            if (esEditar) {
                              movement.id = movimiento!.id;
                              await repo.edit(movement);
                            } else {
                              await repo.create(movement);
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Aceptar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
