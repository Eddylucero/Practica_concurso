import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/motion/motion_form_screen.dart';
import 'screens/motion/motion_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/home',
      routes: {
        '/': (context) => const HomeScreen(),
        '/movimientos': (context) => const MotionScreen(),
        '/movimiento/form': (context) => const MotionFormScreen(),
      },
    );
  }
}
