import 'package:flutter/material.dart';
import 'package:veta_dorada_vinculacion_mobile/core/widgets/protected_scaffold.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';

/// Página principal de ejemplo para el flujo autenticado.
class VisitasTabsPage extends StatelessWidget {
  const VisitasTabsPage({
    super.key,
    required this.usuario,
    required this.token,
    this.puesto,
  });

  /// Usuario autenticado.
  final Usuario usuario;

  /// Token para obtener la foto del usuario.
  final String token;

  /// Puesto del usuario.
  final String? puesto;

  @override
  Widget build(BuildContext context) {
    return ProtectedScaffold(
      usuario: usuario,
      token: token,
      puesto: puesto,
      onNavigate: (ruta) => Navigator.of(context).pushNamed(ruta),
      body: const Center(
        child: Text('Bienvenido al flujo principal'),
      ),
    );
  }
}
