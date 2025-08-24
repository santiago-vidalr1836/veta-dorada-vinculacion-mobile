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
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/entidades/tipo_actividad.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/realizar_verificacion_dto.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/repositorios/verificacion_repository.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/actividad_minera_igafom_pagina.dart';

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

class _FakeVerificacionRepository implements VerificacionRepository {
  RealizarVerificacionDto? _dto;

  @override
  Future<void> guardarVerificacion(RealizarVerificacionDto dto) async {
    _dto = dto;
  }

  @override
  Future<RealizarVerificacionDto?> obtenerVerificacion(int idVisita) async =>
      _dto;

  @override
  Future<List<int>> obtenerVisitasConVerificacion() async =>
      _dto == null ? [] : [_dto!.idVisita];
}

void main() {
  testWidgets('carga inicial de combos', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Exploración'),
      TipoActividad(id: 2, nombre: 'Beneficio'),
    ]);

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraIgafomPagina(
        repository: repo,
        verificacionRepository: _FakeVerificacionRepository(),
        idVisita: 0,
        flagEstimacionProduccion: false,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();

    expect(find.text('Exploración'), findsOneWidget);
    expect(find.text('Beneficio'), findsOneWidget);
  });

  testWidgets('cambia combo secundario al seleccionar otro tipo', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Explotación'),
      TipoActividad(id: 2, nombre: 'Beneficio'),
    ]);

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraIgafomPagina(
        repository: repo,
        verificacionRepository: _FakeVerificacionRepository(),
        idVisita: 0,
        flagEstimacionProduccion: false,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Explotación').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    expect(find.text('Aluvial'), findsOneWidget);
    expect(find.text('Filoniano'), findsOneWidget);
    await tester.tap(find.text('Aluvial').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beneficio').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    expect(find.text('Gravimétrico'), findsOneWidget);
    expect(find.text('Lixiviación'), findsOneWidget);
    expect(find.text('Aluvial'), findsNothing);
  });

  testWidgets('navega a registro fotografico al guardar', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Explotación'),
    ]);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => ActividadMineraIgafomPagina(
            repository: repo,
            verificacionRepository: _FakeVerificacionRepository(),
            idVisita: 0,
            flagEstimacionProduccion: false,
          ),
        ),
        GoRoute(
          path: '/flujo-visita/actividad-verificada',
          builder: (context, state) => const Placeholder(),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

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
  });
}

