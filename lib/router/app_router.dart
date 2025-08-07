import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/widgets/protected_scaffold.dart';
import '../core/red/cliente_http.dart';
import '../features/autenticacion/presentacion/paginas/login_page.dart';
import '../features/perfil/datos/fuentes_datos/perfil_remote_data_source.dart';
import '../features/perfil/datos/modelos/usuario.dart';
import '../features/visitas/presentacion/paginas/visitas_tabs_page.dart';

/// Contiene la información necesaria para construir las rutas protegidas.
class _AuthData {
  const _AuthData(this.usuario, this.token);

  final Usuario usuario;
  final String token;
}

/// Carga el token y los datos del usuario desde el almacenamiento seguro.
Future<_AuthData?> _loadAuthData() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'accessToken');
  if (token == null) return null;

  final client = ClienteHttp(token: token);
  final perfilDataSource = PerfilRemoteDataSource(client);
  try {
    final usuario = await perfilDataSource.obtenerPerfil();
    return _AuthData(usuario, token);
  } catch (_) {
    return null;
  }
}

final Future<_AuthData?> _authDataFuture = _loadAuthData();

/// Configuración principal del enrutador de la aplicación.
final GoRouter appRouter = GoRouter(
  initialLocation: '/visitas',
  redirect: (context, state) async {
    final authData = await _authDataFuture;
    final loggedIn = authData != null;
    final loggingIn = state.location == '/login';
    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/visitas';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return FutureBuilder<_AuthData?>(
          future: _authDataFuture,
          builder: (context, snapshot) {
            final authData = snapshot.data;
            if (authData == null) {
              return const SizedBox.shrink();
            }
            return ProtectedScaffold(
              body: navigationShell,
              usuario: authData.usuario,
              token: authData.token,
              onNavigate: (ruta) => context.go(ruta),
            );
          },
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/visitas',
              builder: (context, state) => const VisitasTabsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
