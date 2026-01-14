import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Financiero'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí luego va el KPI / resumen financiero
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Resumen financiero\n(Próximamente)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Botón principal
            Container(
              height: 55,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/movimientos');
                },
                child: const Text(
                  'Gestionar Movimientos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
