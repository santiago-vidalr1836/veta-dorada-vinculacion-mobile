import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/fuentes_datos/perfil_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';

void main() {
  group('PerfilRemoteDataSource', () {
    test('obtenerPerfil retorna usuario en exito', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'codigoRespuesta': 1,
            'respuesta': {
              'id': '1',
              'nombre': 'Juan',
              'correo': 'juan@example.com',
            }
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final client = ClienteHttp(token: 'token', inner: mockClient);
      final dataSource = PerfilRemoteDataSource(client);

      final result = await dataSource.obtenerPerfil();

      expect(result.codigoRespuesta, RespuestaBase.RESPUESTA_CORRECTA);
      final usuario = result.respuesta;
      expect(usuario, isA<Usuario>());
      expect(usuario!.id, '1');
      expect(usuario.nombre, 'Juan');
      expect(usuario.correo, 'juan@example.com');
    });

    test('obtenerPerfil retorna error en fallo', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'codigoRespuesta': -1,
            'mensaje': 'Perfil no encontrado',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final client = ClienteHttp(token: 'token', inner: mockClient);
      final dataSource = PerfilRemoteDataSource(client);

      final result = await dataSource.obtenerPerfil();

      expect(result.codigoRespuesta, RespuestaBase.RESPUESTA_ERROR);
      expect(result.respuesta, isNull);
      expect(result.mensajeError, 'Perfil no encontrado');
    });
  });
}

