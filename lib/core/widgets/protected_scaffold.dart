import 'package:flutter/material.dart';

import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';
import 'side_nav.dart';
import 'user_toolbar.dart';

/// `Scaffold` reutilizable que integra el `SideNav` y el `UserToolbar` para
/// las rutas que requieren autenticación.
class ProtectedScaffold extends StatefulWidget {
  const ProtectedScaffold({
    super.key,
    required this.body,
    required this.usuario,
    required this.token,
    this.puesto,
    required this.onNavigate,
  });

  /// Contenido principal de la página.
  final Widget body;

  /// Usuario autenticado.
  final Usuario usuario;

  /// Token para obtener la foto del usuario.
  final String token;

  /// Puesto del usuario.
  final String? puesto;

  /// Callback de navegación utilizado por el `SideNav`.
  final void Function(String ruta) onNavigate;

  @override
  State<ProtectedScaffold> createState() => _ProtectedScaffoldState();
}

class _ProtectedScaffoldState extends State<ProtectedScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideNav(
        usuario: widget.usuario,
        onNavigate: widget.onNavigate,
      ),
      appBar: UserToolbar(
        usuario: widget.usuario,
        token: widget.token,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: widget.body,
    );
  }
}
