import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/servicios/servicio_bd_local.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/fuentes_datos/tipo_actividad_local_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/fuentes_datos/tipo_actividad_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/repositorios/actividad_repository_impl.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/entidades/tipo_actividad.dart';
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

void main() {
  testWidgets('carga inicial de combos', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, descripcion: 'Exploración'),
      TipoActividad(id: 2, descripcion: 'Beneficio'),
    ]);

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraReinfoPagina(repository: repo),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<TipoActividad>));
    await tester.pumpAndSettle();

    expect(find.text('Exploración'), findsOneWidget);
    expect(find.text('Beneficio'), findsOneWidget);
  });

  testWidgets('cambia combo secundario al seleccionar otro tipo', (tester) async {
    final repo = _FakeRepository([
      TipoActividad(id: 1, descripcion: 'Explotación'),
      TipoActividad(id: 2, descripcion: 'Beneficio'),
    ]);

    await tester.pumpWidget(MaterialApp(
      home: ActividadMineraReinfoPagina(repository: repo),
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
}

