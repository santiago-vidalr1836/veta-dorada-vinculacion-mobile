import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_notifier.dart';
import '../core/widgets/protected_scaffold.dart';
import '../features/autenticacion/presentacion/paginas/login_page.dart';
import '../features/visitas/presentacion/paginas/visitas_tabs_page.dart';

/// Crea la configuración del enrutador principal de la aplicación.
GoRouter createRouter(AuthNotifier authNotifier) {
  return GoRouter(
    initialLocation: '/visitas',
    redirect: (context, state) {
      final loggedIn = authNotifier.isAuthenticated;
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
          final usuario = authNotifier.usuario;
          final token = authNotifier.token;
          if (usuario == null || token == null) {
            return const SizedBox.shrink();
          }
          return ProtectedScaffold(
            body: navigationShell,
            usuario: usuario,
            token: token,
            onNavigate: (ruta) => context.go(ruta),
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
}
