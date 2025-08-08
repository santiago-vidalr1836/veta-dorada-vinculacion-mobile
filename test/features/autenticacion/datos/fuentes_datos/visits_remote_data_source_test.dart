import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/datos/fuentes_datos/visits_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/datos/modelos/visita_model.dart';

void main() {
  group('VisitsRemoteDataSource', () {
    test('obtenerVisitas retorna lista en exito', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'id': 'v1',
              'general': {
                'estado': 'PROGRAMADA',
                'fechaProgramada': '2023-01-01T00:00:00.000Z',
                'fechaEjecucion': null,
                'observaciones': null,
              },
              'proveedor': {'id': 'p1', 'nombre': 'Proveedor 1'},
              'tipoVisita': {'id': 't1', 'descripcion': 'Tipo'},
              'derechoMinero': {
                'id': 'd1',
                'codigo': 'DM1',
                'nombre': 'Derecho 1',
              },
            }
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final client = ClienteHttp(token: 'token', inner: mockClient);
      final dataSource = VisitsRemoteDataSource(client);

      final result = await dataSource.obtenerVisitas('g1');

      expect(result.codigoRespuesta, RespuestaBase.RESPUESTA_CORRECTA);
      final visitas = result.respuesta;
      expect(visitas, isA<List<VisitaModel>>());
      expect(visitas, hasLength(1));
      expect(visitas![0].id, 'v1');
      expect(visitas[0].proveedor.nombre, 'Proveedor 1');
    });

    test('obtenerVisitas retorna error en fallo', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server error', 500);
      });
      final client = ClienteHttp(token: 'token', inner: mockClient);
      final dataSource = VisitsRemoteDataSource(client);

      final result = await dataSource.obtenerVisitas('g1');

      expect(result.codigoRespuesta, RespuestaBase.RESPUESTA_ERROR);
      expect(result.respuesta, isNull);
      expect(result.mensajeError, 'Error al obtener visitas: 500');
    });
  });
}

