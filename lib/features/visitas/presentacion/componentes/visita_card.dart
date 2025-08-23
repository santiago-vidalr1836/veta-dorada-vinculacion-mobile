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
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      'Est. producción',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF191C20),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ],
                ),
              ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

