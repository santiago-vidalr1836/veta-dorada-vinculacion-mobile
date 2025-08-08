import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';

import '../modelos/usuario.dart';

/// Fuente de datos remota que obtiene el perfil del usuario desde la API.
class PerfilRemoteDataSource {
  PerfilRemoteDataSource(this._client);

  final ClienteHttp _client;

  /// Realiza una solicitud GET a `/api/perfil` y devuelve una [RespuestaBase]
  /// con un [Usuario].
  Future<RespuestaBase<Usuario>> obtenerPerfil() async {
    debugPrint('${EnvironmentConfig.apiBaseUrl}/api/perfil');
    final uri = Uri.parse('${EnvironmentConfig.apiBaseUrl}/api/perfil');
    final response = await _client.get(uri);
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final codigo = data['codigoRespuesta'] as int?;
      if (codigo == RespuestaBase.RESPUESTA_CORRECTA &&
          data['respuesta'] != null) {
        final usuario =
            Usuario.fromJson(data['respuesta'] as Map<String, dynamic>);
        return RespuestaBase.respuestaCorrecta(usuario);
      } else {
        return RespuestaBase.respuestaError(
          data['mensaje']?.toString() ?? 'Error al obtener el perfil',
        );
      }
    } else {
      return RespuestaBase.respuestaError(
        'Error al obtener el perfil: ${response.statusCode}',
      );
    }
  }
}

