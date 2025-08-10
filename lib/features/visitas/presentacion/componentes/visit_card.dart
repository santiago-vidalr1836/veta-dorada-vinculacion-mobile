import 'package:flutter/material.dart';

import '../../dominio/entidades/visita.dart';

/// Tarjeta que muestra la información principal de una [Visita].
class VisitCard extends StatelessWidget {
  const VisitCard({
    super.key,
    required this.visita,
    this.acopiador = '-',
  });

  /// Visita que se va a mostrar.
  final Visita visita;

  /// Nombre del acopiador asignado a la visita.
  final String acopiador;

  @override
  Widget build(BuildContext context) {
    final fecha = visita.estado.fechaProgramada;
    final fechaStr =
        '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              visita.tipoVisita.descripcion,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Código: ${visita.derechoMinero.codigo}'),
            Text('Proveedor: ${visita.proveedor.nombre}'),
            Text('Derecho minero: ${visita.derechoMinero.nombre}'),
            Text('Acopiador: $acopiador'),
            Text('Fecha: $fechaStr'),
          ],
        ),
      ),
    );
  }
}

