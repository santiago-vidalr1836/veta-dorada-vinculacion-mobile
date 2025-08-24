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
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/entidades/actividad.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/enums/origen.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/descripcion.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/evaluacion.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/estimacion.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/foto.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/proveedor_snapshot.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/realizar_verificacion_dto.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/repositorios/verificacion_repository.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/actividad_minera_reinfo_pagina.dart';

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

class _FakeLocalDataSource extends TipoActividadLocalDataSource {
  _FakeLocalDataSource(this._tipos)
      : super(ServicioBdLocal());

  final List<TipoActividad> _tipos;
  int obtenerCalls = 0;

  @override
  Future<List<TipoActividad>> obtenerTiposActividad() async {
    obtenerCalls++;
    return _tipos;
  }

  @override
  Future<void> reemplazarTiposActividad(List<TipoActividad> tipos) async {}
}

class _MockVerificacionRepository implements VerificacionRepository {
  RealizarVerificacionDto? dto;
  RealizarVerificacionDto? savedDto;
  int obtenerCalls = 0;
  int guardarCalls = 0;

  @override
  Future<RealizarVerificacionDto?> obtenerVerificacion(int idVisita) async {
    obtenerCalls++;
    return dto;
  }

  @override
  Future<void> guardarVerificacion(RealizarVerificacionDto dto) async {
    guardarCalls++;
    savedDto = dto;
  }

  @override
  Future<List<int>> obtenerVisitasConVerificacion() async => [];
}

void main() {
  testWidgets('carga inicial de combos', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Exploración'),
      TipoActividad(id: 2, nombre: 'Beneficio'),
    ]);
    final verificacionRepo = _MockVerificacionRepository();

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraReinfoPagina(
        repository: repo,
        verificacionRepository: verificacionRepo,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();

    expect(find.text('Exploración'), findsOneWidget);
    expect(find.text('Beneficio'), findsOneWidget);
  });

  testWidgets('obtiene subtipos desde TipoActividadLocalDataSource',
      (tester) async {
    final local = _FakeLocalDataSource([
      TipoActividad(id: 1, nombre: 'Explotación'),
    ]);
    final repo = ActividadRepositoryImpl(
      TipoActividadRemoteDataSource(
        ClienteHttp(token: '', inner: MockClient((_) async => http.Response('', 500))),
      ),
      local,
    );
    final verificacionRepo = _MockVerificacionRepository();

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraReinfoPagina(
        repository: repo,
        verificacionRepository: verificacionRepo,
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
    expect(local.obtenerCalls, 1);
  });

  testWidgets('_labelSubTipo proviene del campo dinamico del tipo',
      (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Explotación'),
      TipoActividad(id: 2, nombre: 'Beneficio'),
    ]);
    final verificacionRepo = _MockVerificacionRepository();

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraReinfoPagina(
        repository: repo,
        verificacionRepository: verificacionRepo,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Explotación').last);
    await tester.pumpAndSettle();

    expect(find.text('Tipo de Explotación'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beneficio').last);
    await tester.pumpAndSettle();

    expect(find.text('Tipo de Beneficio'), findsOneWidget);
  });

  testWidgets('cambia combo secundario al seleccionar otro tipo', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Explotación'),
      TipoActividad(id: 2, nombre: 'Beneficio'),
    ]);
    final verificacionRepo = _MockVerificacionRepository();

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraReinfoPagina(
        repository: repo,
        verificacionRepository: verificacionRepo,
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

  testWidgets('guarda actividad en verificacionRepository', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Explotación'),
    ]);
    final verificacionRepo = _MockVerificacionRepository();

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraReinfoPagina(
        repository: repo,
        verificacionRepository: verificacionRepo,
      ),
    ));
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

    expect(verificacionRepo.guardarCalls, 1);
    final saved = verificacionRepo.savedDto;
    expect(saved, isNotNull);
    expect(saved!.actividades, hasLength(1));
    expect(saved.actividades.first.idTipoActividad, 1);
    expect(saved.actividades.first.idSubTipoActividad, 1);
  });

  testWidgets('navega a actividad igafom al guardar', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Explotación'),
    ]);
    final verificacionRepo = _MockVerificacionRepository();

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => ActividadMineraReinfoPagina(
            repository: repo,
            verificacionRepository: verificacionRepo,
          ),
        ),
        GoRoute(
          path: '/flujo-visita/actividad-igafom',
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

    expect(router.location, '/flujo-visita/actividad-igafom');
  });

  testWidgets('precarga datos si existe actividad previa', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, nombre: 'Exploración'),
    ]);
    final verificacionRepo = _MockVerificacionRepository();
    verificacionRepo.dto = RealizarVerificacionDto(
      idVerificacion: 0,
      idVisita: 0,
      idUsuario: 0,
      fechaInicioMovil: DateTime.now(),
      fechaFinMovil: DateTime.now(),
      proveedorSnapshot: const ProveedorSnapshot(
        tipoPersona: '',
        nombre: '',
        inicioFormalizacion: false,
      ),
      actividades: const [
        Actividad(
          id: '1',
          origen: Origen.reinfo,
          idTipoActividad: 1,
          idSubTipoActividad: 2,
          sistemaUTM: 18,
          utmEste: 100,
          utmNorte: 200,
          zonaUTM: 19,
          descripcion: null,
        ),
      ],
      descripcion: const Descripcion(
        coordenadas: '',
        zona: '',
        actividad: '',
        equipos: '',
        trabajadores: '',
        condicionesLaborales: '',
      ),
      evaluacion: const Evaluacion(idCondicionProspecto: '', anotacion: ''),
      estimacion: const Estimacion(
        capacidadDiaria: 0,
        diasOperacion: 0,
        produccionEstimada: 0,
      ),
      fotos: const <Foto>[],
      idempotencyKey: '',
    );

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraReinfoPagina(
        repository: repo,
        verificacionRepository: verificacionRepo,
      ),
    ));
    await tester.pumpAndSettle();

    final tipoField = tester.widget<DropdownButtonFormField<TipoActividad>>(
        find.byType(DropdownButtonFormField<TipoActividad>));
    expect(tipoField.value?.id, 1);

    final subTipoField =
        tester.widget<DropdownButtonFormField<String>>(find.byType(
            DropdownButtonFormField<String>));
    expect(subTipoField.value, 'Filoniano');

    final sistemaField =
        tester.widget<TextFormField>(find.bySemanticsLabel('Sistema UTM'));
    expect(sistemaField.controller?.text, '18');
  });
}

