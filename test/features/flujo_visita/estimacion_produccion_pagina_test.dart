import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/estimacion_produccion_pagina.dart';

void main() {
  testWidgets('muestra indicador cuando flag es true', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: EstimacionProduccionPagina(flagMedicionCapacidad: true),
    ));

    expect(find.text('Capacidad operativa habilitada'), findsOneWidget);
  });

  testWidgets('oculta indicador cuando flag es false', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: EstimacionProduccionPagina(flagMedicionCapacidad: false),
    ));

    expect(find.text('Capacidad operativa habilitada'), findsNothing);
  });
}
