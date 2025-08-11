import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_notifier.dart';
import '../core/auth/auth_provider.dart';
import '../core/red/cliente_http.dart';
import '../core/servicios/servicio_bd_local.dart';
import '../core/widgets/protected_scaffold.dart';
import '../features/actividad/datos/fuentes_datos/tipo_actividad_local_data_source.dart';
import '../features/actividad/datos/fuentes_datos/tipo_actividad_remote_data_source.dart';
import '../features/actividad/datos/repositorios/actividad_repository_impl.dart';
import '../features/actividad/dominio/entidades/actividad.dart';
import '../features/autenticacion/presentacion/paginas/login_page.dart';
import '../features/flujo_visita/presentacion/paginas/actividad_minera_reinfo_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/actividad_minera_igafom_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/actividad_minera_verificada_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/descripcion_actividad_minera_verificada_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/datos_proveedor_mineral_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/registro_fotografico_verificacion_pagina.dart';
import '../features/visitas/presentacion/paginas/visitas_tabs_page.dart';

/// Crea la configuración del enrutador principal de la aplicación.
GoRouter createRouter(AuthNotifier authNotifier) {
  return GoRouter(
    initialLocation: '/visitas',
    redirect: (context, state) {
      final loggedIn = authNotifier.isAuthenticated;
      final loggingIn = state.uri.toString() == '/login';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/visitas';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/flujo-visita/actividad-reinfo',
        builder: (context, state) {
          final auth = AuthProvider.of(context);
          final repo = ActividadRepositoryImpl(
            TipoActividadRemoteDataSource(ClienteHttp(token: auth.token!)),
            TipoActividadLocalDataSource(ServicioBdLocal()),
          );
          return ActividadMineraReinfoPagina(repository: repo);
        },
      ),
      GoRoute(
        path: '/flujo-visita/actividad-verificada',
        builder: (context, state) {
          final auth = AuthProvider.of(context);
          final repo = ActividadRepositoryImpl(
            TipoActividadRemoteDataSource(ClienteHttp(token: auth.token!)),
            TipoActividadLocalDataSource(ServicioBdLocal()),
          );
          return ActividadMineraVerificadaPagina(repository: repo);
        },
      ),
      GoRoute(
        path: '/flujo-visita/descripcion-actividad-verificada',
        builder: (context, state) {
          final actividad = state.extra! as Actividad;
          return DescripcionActividadMineraVerificadaPagina(
            actividad: actividad,
          );
        },
      ),
      GoRoute(
        path: '/flujo-visita/actividad-igafom',
        builder: (context, state) {
          final auth = AuthProvider.of(context);
          final repo = ActividadRepositoryImpl(
            TipoActividadRemoteDataSource(ClienteHttp(token: auth.token!)),
            TipoActividadLocalDataSource(ServicioBdLocal()),
          );
          return ActividadMineraIgafomPagina(repository: repo);
        },
      ),
      GoRoute(
        path: '/flujo-visita/registro-fotografico',
        builder: (context, state) {
          final actividad = state.extra! as Actividad;
          return RegistroFotograficoVerificacionPagina(actividad: actividad);
        },
      ),
      GoRoute(
        path: '/flujo-visita/datos-proveedor',
        builder: (context, state) {
          final actividad = state.extra! as Actividad;
          return DatosProveedorMineralPagina(actividad: actividad);
        },
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
