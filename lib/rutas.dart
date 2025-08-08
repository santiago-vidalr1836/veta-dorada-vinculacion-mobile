import 'package:flutter/material.dart';

import 'core/constantes/rutas.dart';
import 'core/widgets/protected_scaffold.dart';
import 'features/perfil/datos/modelos/usuario.dart';
import 'features/visitas/presentacion/paginas/visitas_tabs_page.dart';

/// Tipo de constructor para las rutas que requieren parámetros adicionales.
typedef RutaBuilder = Widget Function(
    BuildContext context, Usuario usuario, String token);

/// Mapa de rutas de la aplicación.
final Map<String, RutaBuilder> rutas = {
  rutaVisitas: (context, usuario, token) => ProtectedScaffold(
        body: const VisitasTabsPage(),
        usuario: usuario,
        token: token,
        onNavigate: (ruta) => Navigator.of(context).pushNamed(ruta),
      ),
};
