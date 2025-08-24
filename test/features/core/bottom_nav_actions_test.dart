import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veta_dorada_vinculacion_mobile/core/widgets/bottom_nav_actions.dart';

void main() {
  testWidgets(
      'Botón "Siguiente" ocupa todo el ancho cuando no se muestra "Atrás"',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BottomNavActions(
            onNext: _dummy,
            showBack: false,
          ),
        ),
      ),
    );

    final screenWidth =
        tester.binding.window.physicalSize.width /
            tester.binding.window.devicePixelRatio;
    final buttonWidth =
        tester.getSize(find.byType(ElevatedButton)).width;

    expect(buttonWidth, moreOrLessEquals(screenWidth, epsilon: 1));
  });

  testWidgets(
      'Se muestran ambos botones cuando mostrarAtras es verdadero',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BottomNavActions(
            onNext: _dummy,
            showBack: true,
          ),
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    final screenWidth =
        tester.binding.window.physicalSize.width /
            tester.binding.window.devicePixelRatio;
    final buttonWidth =
        tester.getSize(find.byType(ElevatedButton)).width;

    expect(buttonWidth, lessThan(screenWidth));
  });
}

void _dummy() {}
