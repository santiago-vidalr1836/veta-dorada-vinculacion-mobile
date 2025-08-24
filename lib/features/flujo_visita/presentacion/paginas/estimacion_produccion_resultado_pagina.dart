import 'package:flutter/material.dart';

import '../../dominio/entidades/estimacion.dart';

/// Página que muestra el resultado de la estimación de producción.
class EstimacionProduccionResultadoPagina extends StatelessWidget {
  const EstimacionProduccionResultadoPagina({
    super.key,
    required this.estimacion,
  });

  /// Estimación calculada con todos los parámetros y resultados.
  final Estimacion estimacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado de Estimación')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Producción diaria estimada (Pd): '
              '${estimacion.produccionDiariaEstimada.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Producción mensual estimada (pme): '
              '${estimacion.produccionMensualEstimada.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Producción mensual: '
              '${estimacion.produccionMensual.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
