import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../repositories/movement_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovementRepository repo = MovementRepository();

  double ingresos = 0;
  double gastos = 0;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarResumen();
  }

  Future<void> cargarResumen() async {
    setState(() => cargando = true);

    ingresos = await repo.getTotalIngresos();
    gastos = await repo.getTotalGastos();

    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    final balance = ingresos - gastos;
    final maxValor = (ingresos > gastos ? ingresos : gastos) * 1.2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Financiero'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ================= KPI =================
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Resumen Financiero',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('Ingresos: \$${ingresos.toStringAsFixed(2)}'),
                        Text('Gastos: \$${gastos.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        Text(
                          'Balance: \$${balance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: balance >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ================= GRÁFICO =================
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 280,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxValor == 0 ? 100 : maxValor,
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.black87,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                    final label = group.x == 0
                                        ? 'Ingresos'
                                        : 'Gastos';
                                    return BarTooltipItem(
                                      '$label\n\$${rod.toY.toStringAsFixed(2)}',
                                      const TextStyle(color: Colors.white),
                                    );
                                  },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: maxValor / 4,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '\$${value.toInt()}',
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40, // 🔥 SOLUCIÓN CLAVE
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      value.toInt() == 0
                                          ? 'Ingresos'
                                          : 'Gastos',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: ingresos,
                                  color: Colors.green,
                                  width: 45,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: gastos,
                                  color: Colors.red,
                                  width: 45,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                          ],
                        ),
                        swapAnimationDuration: const Duration(
                          milliseconds: 500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ================= BOTÓN =================
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/movimientos');
                        cargarResumen();
                      },
                      child: const Text(
                        'Gestionar Movimientos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
