import 'package:flutter/material.dart';

/// Página que muestra el resultado de la estimación de producción.
class EstimacionProduccionResultadoPagina extends StatelessWidget {
  const EstimacionProduccionResultadoPagina({
    super.key,
    required this.estimacion,
  });

  /// Valor calculado de la producción estimada.
  final double estimacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado de Estimación')),
      body: Center(
        child: Text(
          'Producción estimada: ${estimacion.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
