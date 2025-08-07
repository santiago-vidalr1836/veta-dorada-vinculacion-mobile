import 'package:flutter/material.dart';

import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';

/// Widget que representa el menú lateral de navegación.
///
/// Muestra la información básica del [usuario] y permite navegar a otras
/// secciones utilizando el callback [onNavigate].
class SideNav extends StatelessWidget {
  const SideNav({
    super.key,
    required this.usuario,
    required this.onNavigate,
  });

  /// Información del usuario autenticado.
  final Usuario usuario;

  /// Callback que se ejecuta al seleccionar una opción de navegación.
  /// Se pasa la ruta seleccionada como parámetro.
  final void Function(String ruta) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(usuario.nombre),
            accountEmail: Text(usuario.correo),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => onNavigate('/'),
          ),
        ],
      ),
    );
  }
}
