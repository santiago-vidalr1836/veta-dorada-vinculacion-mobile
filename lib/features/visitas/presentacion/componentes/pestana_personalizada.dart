import 'package:flutter/material.dart';

/// Pestaña con estilo personalizado utilizada en el [TabBar] de visitas.
class PestanaPersonalizada extends StatelessWidget {
  const PestanaPersonalizada({super.key, required this.titulo});

  /// Texto que se muestra en la pestaña.
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        titulo,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

