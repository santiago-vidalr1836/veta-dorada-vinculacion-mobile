import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/visita.dart';

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
import '../features/flujo_visita/datos/fuentes_datos/general_local_data_source.dart';
import '../features/flujo_visita/datos/fuentes_datos/general_remote_data_source.dart';
import '../features/flujo_visita/datos/repositorios/general_repository.dart';
import '../features/flujo_visita/datos/fuentes_datos/verificacion_remote_data_source.dart';
import '../features/flujo_visita/datos/repositorios/flow_repository_impl.dart';
import '../features/flujo_visita/datos/fuentes_datos/verificacion_local_data_source.dart';
import '../features/flujo_visita/datos/repositorios/verificacion_repository_impl.dart';
import '../features/flujo_visita/presentacion/paginas/actividad_minera_reinfo_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/actividad_minera_igafom_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/actividad_minera_verificada_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/descripcion_actividad_minera_verificada_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/datos_proveedor_mineral_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/evaluacion_labor_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/firma_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/firma_digital_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/registro_fotografico_verificacion_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/estimacion_produccion_pagina.dart';
import '../features/flujo_visita/presentacion/paginas/estimacion_produccion_resultado_pagina.dart';
import '../features/visitas/presentacion/paginas/visitas_tabs_page.dart';

/// Crea la configuración del enrutador principal de la aplicación.
GoRouter createRouter(AuthNotifier authNotifier) {
  final flowRepository = FlowRepositoryImpl(
    VerificacionRemoteDataSource(
      ClienteHttp(token: authNotifier.token ?? ''),
    ),
  );
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
          final verificacionRepo = VerificacionRepositoryImpl(
            VerificacionLocalDataSource(ServicioBdLocal()),
          );
          return ActividadMineraReinfoPagina(
            repository: repo,
            verificacionRepository: verificacionRepo,
          );
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
          final flag = state.extra as bool? ?? false;
          return ActividadMineraVerificadaPagina(
            repository: repo,
            flagMedicionCapacidad: flag,
          );
        },
      ),
      GoRoute(
        path: '/flujo-visita/descripcion-actividad-verificada',
        builder: (context, state) {
          final extras = state.extra! as Map<String, dynamic>;
          final actividad = extras['actividad'] as Actividad;
          final flag = extras['flagMedicionCapacidad'] as bool;
          return DescripcionActividadMineraVerificadaPagina(
            actividad: actividad,
            flagMedicionCapacidad: flag,
            flowRepository: flowRepository,
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
          final actividad = state.extra as Actividad?;
          return ActividadMineraIgafomPagina(
            repository: repo,
            actividadReinfo: actividad,
          );
        },
      ),
      GoRoute(
        path: '/flujo-visita/registro-fotografico',
        builder: (context, state) {
          final extras = state.extra! as Map<String, dynamic>;
          final actividad = extras['actividad'] as Actividad;
          final flag = extras['flagMedicionCapacidad'] as bool;
          return RegistroFotograficoVerificacionPagina(
            actividad: actividad,
            flagMedicionCapacidad: flag,
            flowRepository: flowRepository,
          );
        },
      ),
      GoRoute(
        path: '/flujo-visita/evaluacion-labor',
        builder: (context, state) {
          final auth = AuthProvider.of(context);
          final repo = GeneralRepository(
            GeneralRemoteDataSource(ClienteHttp(token: auth.token!)),
            GeneralLocalDataSource(ServicioBdLocal()),
          );
          final extras = state.extra! as Map<String, dynamic>;
          final actividad = extras['actividad'] as Actividad;
          final flag = extras['flagMedicionCapacidad'] as bool;
          return EvaluacionLaborPagina(
            actividad: actividad,
            repository: repo,
            flagMedicionCapacidad: flag,
            flowRepository: flowRepository,
          );
        },
      ),
      GoRoute(
        path: '/flujo-visita/estimacion-produccion',
        builder: (context, state) {
          final flag = state.extra as bool? ?? false;
          return EstimacionProduccionPagina(
            flagMedicionCapacidad: flag,
            flowRepository: flowRepository,
          );
        },
      ),
      GoRoute(
        path: '/flujo-visita/estimacion-produccion/resultado',
        builder: (context, state) {
          final estimacion = state.extra as double? ?? 0;
          return EstimacionProduccionResultadoPagina(estimacion: estimacion);
        },
      ),
      GoRoute(
        path: '/flujo-visita/firma',
        builder: (context, state) {
          final auth = AuthProvider.of(context);
          final extras = state.extra! as Map<String, dynamic>;
          final actividad = extras['actividad'] as Actividad;
          final flag = extras['flagMedicionCapacidad'] as bool;
          return FirmaPagina(
            actividad: actividad,
            usuario: auth.usuario!,
            flagMedicionCapacidad: flag,
          );
        },
      ),
      GoRoute(
        path: '/flujo-visita/firma-digital',
        builder: (context, state) => const FirmaDigitalPagina(),
      ),
      GoRoute(
        path: '/flujo-visita/datos-proveedor',
        builder: (context, state) {
          final auth = AuthProvider.of(context);
          final repo = GeneralRepository(
            GeneralRemoteDataSource(ClienteHttp(token: auth.token!)),
            GeneralLocalDataSource(ServicioBdLocal()),
          );
          final verificacionRepo = VerificacionRepositoryImpl(
            VerificacionLocalDataSource(ServicioBdLocal()),
          );
          final visita = state.extra! as Visita;
          return DatosProveedorMineralPagina(
            visita: visita,
            repository: repo,
            verificacionRepository: verificacionRepo,
          );
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
