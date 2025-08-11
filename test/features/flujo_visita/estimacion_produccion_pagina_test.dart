import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/estimacion_produccion_pagina.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/estimacion_produccion_resultado_pagina.dart';

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

  testWidgets('navega a pantalla de resultado al estimar', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const EstimacionProduccionPagina(flagMedicionCapacidad: false),
        ),
        GoRoute(
          path: '/resultado',
          builder: (context, state) {
            final estimacion = state.extra as double;
            return EstimacionProduccionResultadoPagina(
                estimacion: estimacion);
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.enterText(find.byType(TextFormField).at(0), '10');
    await tester.enterText(find.byType(TextFormField).at(1), '2');
    await tester.tap(find.text('Estimar'));
    await tester.pumpAndSettle();

    expect(find.text('Producción estimada: 20.00'), findsOneWidget);
  });
}
