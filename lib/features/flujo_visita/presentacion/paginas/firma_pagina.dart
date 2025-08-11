import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../actividad/dominio/entidades/actividad.dart';
import '../../../perfil/datos/modelos/usuario.dart';

/// Página para visualizar la información del usuario antes de firmar.
class FirmaPagina extends StatelessWidget {
  const FirmaPagina({
    super.key,
    required this.actividad,
    required this.usuario,
  });

  /// Actividad asociada a la firma.
  final Actividad actividad; // ignore: unused_field

  /// Usuario que realizará la firma.
  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    // Se obtiene el usuario autenticado por si cambia durante la navegación.
    final currentUser = AuthProvider.of(context).usuario ?? usuario;

    return Scaffold(
      appBar: AppBar(title: const Text('Firma')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DNI: ${currentUser.id}'),
            const SizedBox(height: 8),
            Text('Nombre y apellidos: ${currentUser.nombre}'),
            const SizedBox(height: 8),
            Text('Cargo: ${currentUser.correo}'),
            const SizedBox(height: 8),
            const Text('Jefatura: -'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                context.push('/flujo-visita/firma-digital'),
            child: const Text('Firmar'),
          ),
        ),
      ),
    );
  }
}

