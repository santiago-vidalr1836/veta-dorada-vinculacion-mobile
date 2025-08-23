import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';

/// Barra de herramientas que muestra la información del usuario y controles
/// comunes para las rutas protegidas.
class UserToolbar extends StatelessWidget implements PreferredSizeWidget {
  const UserToolbar({
    super.key,
    required this.usuario,
    required this.token,
    this.onMenuPressed,
  });

  /// Información del usuario autenticado.
  final Usuario usuario;

  /// Token de acceso utilizado para obtener la foto desde Microsoft Graph.
  final String token;

  /// Callback que se ejecuta al presionar el botón de menú para abrir el
  /// [Drawer].
  final VoidCallback? onMenuPressed;

  /// Obtiene la imagen de perfil del usuario desde Microsoft Graph.
  Future<Uint8List?> _fetchPhoto() async {
    final uri = Uri.parse('https://graph.microsoft.com/v1.0/me/photo/\$value');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ' + token},
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: onMenuPressed,
      ),
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${usuario.nombre} ${usuario.apellidos}', style: const TextStyle(fontSize: 16)),
              Text('${usuario.perfil.nombre} ● ${usuario.oficina.nombre}', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
