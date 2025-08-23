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
          jsonEncode({
            'CodigoRespuesta': 1,
            'Respuesta': [
              {
                'Id': 1,
                'Estado': {
                  'Codigo': 'PRG',
                  'Nombre': 'Programada',
                  'Descripcion': null
                },
                'Proveedor': {
                  'Id': 1,
                  'Tipo': {
                    'Codigo': 'TP',
                    'Nombre': 'Tipo',
                    'Descripcion': null
                  },
                  'Ruc': '12345678901',
                  'NombreCompleto': 'Proveedor 1',
                  'Estado': {
                    'Codigo': 'ACT',
                    'Nombre': 'Activo',
                    'Descripcion': null
                  },
                  'DerechoMinero': []
                },
                'TipoVisita': {
                  'Id': 1,
                  'Codigo': null,
                  'Nombre': 'Tipo'
                },
                'DerechoMinero': {
                  'Id': 1,
                  'CodigoUnico': 'DM1',
                  'Denominacion': 'Derecho 1'
                },
                'FechaProgramada': '2023-01-01T00:00:00.000Z',
                'Geologo': {
                  'Id': 1,
                  'Nombres': 'Geo',
                  'Apellidos': 'Logo',
                  'CorreoElectronico': 'geo@example.com'
                },
                'Acopiador': {
                  'Id': 2,
                  'Nombres': 'Aco',
                  'Apellidos': 'Piador',
                  'CorreoElectronico': 'aco@example.com'
                }
              }
            ]
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final client = ClienteHttp(token: 'token', inner: mockClient);
      final dataSource = VisitsRemoteDataSource(client);

      final result = await dataSource.obtenerVisitas(1);

      expect(result.codigoRespuesta, RespuestaBase.RESPUESTA_CORRECTA);
      final visitas = result.respuesta;
      expect(visitas, isA<List<VisitaModel>>());
      expect(visitas, hasLength(1));
      expect(visitas![0].id, 1);
      expect(visitas[0].proveedor.nombre(), 'Proveedor 1');
    });

    test('obtenerVisitas retorna error en fallo', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'codigoRespuesta': -1,
            'mensaje': 'No se pudo obtener visitas',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final client = ClienteHttp(token: 'token', inner: mockClient);
      final dataSource = VisitsRemoteDataSource(client);

      final result = await dataSource.obtenerVisitas(1);

      expect(result.codigoRespuesta, RespuestaBase.RESPUESTA_ERROR);
      expect(result.respuesta, isNull);
      expect(result.mensajeError, 'No se pudo obtener visitas');
    });
  });
}

