import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../dominio/entidades/visita.dart';

/// Tarjeta que muestra la información principal de una [Visita].
class VisitaCard extends StatelessWidget {
  const VisitaCard({
    super.key,
    required this.visita,
  });

  /// Visita que se va a mostrar.
  final Visita visita;

  @override
  Widget build(BuildContext context) {
    final fecha = visita.fechaProgramada;
    final DateFormat formato = DateFormat("d MMM, HH:mm", "es_ES");
    final fechaStr = formato.format(fecha);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  visita.tipoVisita.nombre,
                  style: TextStyle(
                    color: const Color(0xFF414751),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.50,
                  ),
                ),
                Text(
                  fechaStr,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF414751),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.50,
                  ),
                )
              ],
            ),
            Text(
                '${visita.id}'.padLeft(4, '0'),
                style: TextStyle(
                  color: const Color(0xFF191C20),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                  letterSpacing: 0.50,
                ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic, //
              children: [
                Text(
                  'Proveedor: ',
                  style: TextStyle(
                    color: const Color(0xFF414751) /* Schemes-On-Surface-Variant */,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.50,
                  ),
                ),
                Text(
                  '${visita.proveedor.nombre()}',
                  style: TextStyle(
                    color: const Color(0xFF414751) /* Schemes-On-Surface-Variant */,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                    letterSpacing: 0.40,
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic, //
              children: [
                Text(
                  'Derecho minero: ',
                  style: TextStyle(
                    color: const Color(0xFF414751) /* Schemes-On-Surface-Variant */,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.50,
                  ),
                ),
                Text(
                  visita.derechoMinero.denominacion,
                  style: TextStyle(
                    color: const Color(0xFF414751) /* Schemes-On-Surface-Variant */,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                    letterSpacing: 0.40,
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic, //
              children: [
                Text(
                  'Acopiador: ',
                  style: TextStyle(
                    color: const Color(0xFF414751) /* Schemes-On-Surface-Variant */,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.50,
                  ),
                ),
                Text(
                  '${visita.acopiador.nombre} ${visita.acopiador.apellidos}',
                  style: TextStyle(
                    color: const Color(0xFF414751),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                    letterSpacing: 0.40,
                  ),
                )
              ],
            ),
            if(visita.flagEstimacionProduccion)
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    side: BorderSide(color: const Color(0xFF717782), width: 1)
                  ),
                ),
                onPressed: () {
                  context.push('/flujo-visita/datos-proveedor',
                      extra: {
                        'visita': visita
                      });
                },
                child: const Text('Est. producción'),
              ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

