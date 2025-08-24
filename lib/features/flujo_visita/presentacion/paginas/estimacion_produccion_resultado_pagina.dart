import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';
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
    final auth = AuthProvider.of(context);
    return ProtectedScaffold(
      usuario: auth.usuario!,
      token: auth.token!,
      onNavigate: (ruta) => context.go(ruta),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 378,
              child: Text(
                'Resultado de Estimación',
                style: TextStyle(
                  color: Color(0xFF1D1B20),
                  fontSize: 22,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.27,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
