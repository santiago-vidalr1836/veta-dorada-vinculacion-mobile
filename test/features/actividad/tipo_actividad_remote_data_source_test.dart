import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/fuentes_datos/tipo_actividad_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/entidades/tipo_actividad.dart';

void main() {
  group('TipoActividadRemoteDataSource', () {
    test('convierte respuesta JSON a lista de TipoActividad', () async {
      final mockClient = MockClient((request) async {
        final body = jsonEncode({
          'CodigoRespuesta': RespuestaBase.RESPUESTA_CORRECTA,
          'Respuesta': [
            {'Id': 1, 'Nombre': 'Exploración'},
            {'Id': 2, 'Nombre': 'Beneficio'},
          ],
        });
        return http.Response(body, 200);
      });
      final cliente = ClienteHttp(token: '', inner: mockClient);
      final dataSource = TipoActividadRemoteDataSource(cliente);

      final respuesta = await dataSource.obtenerTiposActividad();

      expect(respuesta.codigoRespuesta, RespuestaBase.RESPUESTA_CORRECTA);
      expect(respuesta.respuesta, isA<List<TipoActividad>>());
      expect(respuesta.respuesta!.length, 2);
      expect(respuesta.respuesta!.first.nombre, 'Exploración');
    });

    test('devuelve error cuando el servidor responde con código no 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });
      final cliente = ClienteHttp(token: '', inner: mockClient);
      final dataSource = TipoActividadRemoteDataSource(cliente);

      final respuesta = await dataSource.obtenerTiposActividad();

      expect(respuesta.codigoRespuesta, RespuestaBase.RESPUESTA_ERROR);
      expect(respuesta.respuesta, isNull);
    });
  });
}

