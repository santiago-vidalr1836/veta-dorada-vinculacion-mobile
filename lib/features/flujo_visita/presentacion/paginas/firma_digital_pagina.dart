import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';

/// Pantalla temporal para la funcionalidad de firma digital.
class FirmaDigitalPagina extends StatelessWidget {
  const FirmaDigitalPagina({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return ProtectedScaffold(
      usuario: auth.usuario!,
      token: auth.token!,
      onNavigate: (ruta) => context.go(ruta),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 378,
              child: Text(
                'Firma digital',
                style: TextStyle(
                  color: Color(0xFF1D1B20),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 1.27,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Pantalla de firma digital (pendiente)'),
          ],
        ),
      ),
    );
  }
}

