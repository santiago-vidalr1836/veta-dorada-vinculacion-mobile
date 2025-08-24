import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/entidades/actividad.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/enums/origen.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/descripcion.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/descripcion_actividad_verificada.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/evaluacion.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/estimacion.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/foto.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/proveedor_snapshot.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/realizar_verificacion_dto.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/repositorios/verificacion_repository.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/presentacion/paginas/descripcion_actividad_minera_verificada_pagina.dart';

class _MockVerificacionRepository implements VerificacionRepository {
  RealizarVerificacionDto? savedDto;

  @override
  Future<void> guardarVerificacion(RealizarVerificacionDto dto) async {
    savedDto = dto;
  }

  @override
  Future<RealizarVerificacionDto?> obtenerVerificacion(int idVisita) async =>
      savedDto;

  @override
  Future<List<int>> obtenerVisitasConVerificacion() async => [];
}

void main() {
  testWidgets('guarda descripción en VerificacionRepository', (tester) async {
    final actividad = const Actividad(
      id: '1',
      origen: Origen.verificada,
      idTipoActividad: 1,
      idSubTipoActividad: 1,
      utmEste: 0,
      utmNorte: 0,
    );
    final dto = RealizarVerificacionDto(
      idVerificacion: 1,
      idVisita: 1,
      idUsuario: 1,
      fechaInicioMovil: DateTime.now(),
      fechaFinMovil: DateTime.now(),
      proveedorSnapshot: const ProveedorSnapshot(
        tipoPersona: '',
        nombre: '',
        inicioFormalizacion: '',
      ),
      actividades: const [],
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
        longitudAvance: 0,
        alturaFrente: 0,
        espesorVeta: 0,
        numeroDisparosDia: 0,
        diasTrabajados: 0,
        porcentajeRocaCaja: 0,
        produccionDiariaEstimada: 0,
        produccionMensualEstimada: 0,
        produccionMensual: 0,
      ),
      fotos: const <Foto>[],
      idempotencyKey: '',
    );

    final verificacionRepo = _MockVerificacionRepository();

    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => DescripcionActividadMineraVerificadaPagina(
          actividad: actividad,
          flagMedicionCapacidad: false,
          flagEstimacionProduccion: false,
          verificacionRepository: verificacionRepo,
          dto: dto,
        ),
      ),
      GoRoute(
        path: '/flujo-visita/registro-fotografico',
        builder: (context, state) => const SizedBox.shrink(),
      ),
    ]);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.bySemanticsLabel('Coordenadas, ubicación geográfica y política'),
        'coord');
    await tester.enterText(
        find.bySemanticsLabel('Zona de la labor minera'), 'zona');
    await tester.enterText(
        find.bySemanticsLabel('Actividad minera verificada'), 'act');
    await tester.enterText(
        find.bySemanticsLabel('Equipos y maquinaria'), 'equip');
    await tester.enterText(
        find.bySemanticsLabel('Trabajadores'), 'trab');
    await tester.enterText(
        find.bySemanticsLabel(
            'Trabajo forzado/infantil, medio ambiente y seguridad'),
        'seg');

    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    final saved = verificacionRepo.savedDto;
    expect(saved, isNotNull);
    expect(saved!.descripcion?.coordenadas, 'coord');
    expect(saved.descripcion?.zona, 'zona');
    expect(saved.descripcion?.actividad, 'act');
    expect(saved.descripcion?.equipos, 'equip');
    expect(saved.descripcion?.trabajadores, 'trab');
    expect(saved.descripcion?.condicionesLaborales, 'seg');
  });
}

