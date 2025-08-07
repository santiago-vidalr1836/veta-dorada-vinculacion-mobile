import 'package:flutter/material.dart';

/// Página principal de ejemplo para el flujo autenticado.
class VisitasTabsPage extends StatelessWidget {
  const VisitasTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MineCheck'),
      ),
      body: const Center(
        child: Text('Bienvenido al flujo principal'),
      ),
    );
  }
}

