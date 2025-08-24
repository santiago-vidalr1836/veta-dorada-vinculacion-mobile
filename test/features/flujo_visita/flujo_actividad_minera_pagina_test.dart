import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:go_router/go_router.dart';

import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/servicios/servicio_bd_local.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/fuentes_datos/tipo_actividad_local_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/fuentes_datos/tipo_actividad_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/repositorios/actividad_repository_impl.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/entidades/actividad.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/entidades/tipo_actividad.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/realizar_verificacion_dto.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/repositorios/verificacion_repository.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/actividad_minera_reinfo_pagina.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/actividad_minera_igafom_pagina.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/actividad_minera_verificada_pagina.dart';

class _FakeRepository extends ActividadRepositoryImpl {
  _FakeRepository(this._tipos)
      : super(
          TipoActividadRemoteDataSource(
            ClienteHttp(token: '', inner: MockClient((_) async => http.Response('', 500))),
          ),
          TipoActividadLocalDataSource(ServicioBdLocal()),
        );

  final List<TipoActividad> _tipos;

  @override
  Future<({List<TipoActividad> tipos, String? advertencia})>
      obtenerTiposActividad() async {
    return (tipos: _tipos, advertencia: null);
  }
}

class _MockVerificacionRepository implements VerificacionRepository {
  RealizarVerificacionDto? dto;
  @override
  Future<RealizarVerificacionDto?> obtenerVerificacion(int idVisita) async => dto;

  @override
  Future<void> guardarVerificacion(RealizarVerificacionDto dto) async {
    this.dto = dto;
  }

  @override
  Future<List<int>> obtenerVisitasConVerificacion() async => [];
}

void main() {
  testWidgets('flujo de actividad minera navega y retrocede', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Explotación'),
    ]);
    final verificacionRepo = _MockVerificacionRepository();

    final router = GoRouter(
      initialLocation: '/flujo-visita/actividad-reinfo',
      routes: [
        GoRoute(
          path: '/flujo-visita/actividad-reinfo',
          builder: (context, state) => ActividadMineraReinfoPagina(
            repository: repo,
            verificacionRepository: verificacionRepo,
            idVisita: 1,
            flagEstimacionProduccion: false,
          ),
        ),
        GoRoute(
          path: '/flujo-visita/actividad-igafom',
          builder: (context, state) {
            final extras = state.extra! as Map<String, dynamic>;
            return ActividadMineraIgafomPagina(
              repository: repo,
              verificacionRepository: verificacionRepo,
              idVisita: extras['idVisita'] as int,
              flagEstimacionProduccion:
                  extras['flagEstimacionProduccion'] as bool,
              actividadReinfo: extras['actividad'] as Actividad?,
            );
          },
        ),
        GoRoute(
          path: '/flujo-visita/actividad-verificada',
          builder: (context, state) {
            final extras = state.extra! as Map<String, dynamic>;
            return ActividadMineraVerificadaPagina(
              repository: repo,
              verificacionRepository: verificacionRepo,
              flagMedicionCapacidad:
                  extras['flagMedicionCapacidad'] as bool,
              flagEstimacionProduccion:
                  extras['flagEstimacionProduccion'] as bool,
              idVisita: extras['idVisita'] as int,
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    // Reinfo -> Igafom
    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Explotación').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aluvial').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/flujo-visita/actividad-igafom');
    expect(
      find.text('Actividad Minera Declarada por el Proveedor de Mineral en el IGAFOM'),
      findsOneWidget,
    );

    // Igafom -> Verificada
    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Explotación').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aluvial').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/flujo-visita/actividad-verificada');
    expect(find.text('Actividad Minera Verificada'), findsOneWidget);

    // Back to Igafom
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/flujo-visita/actividad-igafom');
    expect(
      find.text('Actividad Minera Declarada por el Proveedor de Mineral en el IGAFOM'),
      findsOneWidget,
    );

    // Back to Reinfo
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(router.routerDelegate.currentConfiguration.last.matchedLocation, '/flujo-visita/actividad-reinfo');
    expect(
      find.text(
          'Actividad Minera Declarada por el Proveedor de Mineral en el Comprobante de Recepción de Datos para el REINFO'),
      findsOneWidget,
    );
  });
}

