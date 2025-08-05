import 'package:flutter/material.dart';
import 'features/autenticacion/presentacion/paginas/login_page.dart';

void main() {
  runApp(const MineCheckApp());
}

class MineCheckApp extends StatelessWidget {
  const MineCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MineCheck',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

