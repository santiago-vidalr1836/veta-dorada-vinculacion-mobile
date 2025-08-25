import 'dart:convert';

import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';

import '../../dominio/entidades/tipo_actividad.dart';

/// Fuente de datos remota para obtener los tipos de actividad desde la API.
class TipoActividadRemoteDataSource {
  TipoActividadRemoteDataSource(this._client);

  final ClienteHttp _client;

  /// Realiza una solicitud GET a `/api/TipoActividad` y devuelve los tipos.
  Future<RespuestaBase<List<TipoActividad>>> obtenerTiposActividad() async {
    final uri =
        Uri.parse('${EnvironmentConfig.apiBaseUrl}/api/TipoActividad');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final codigo =
          data['CodigoRespuesta'] as int? ?? RespuestaBase.RESPUESTA_ERROR;
      if (codigo == RespuestaBase.RESPUESTA_CORRECTA &&
          data['Respuesta'] is List) {
        final tipos = (data['Respuesta'] as List<dynamic>).map((e) {
          final json = e as Map<String, dynamic>;
          final subTipos = (json['SubTipos'] as List<dynamic>? ?? [])
              .map(
                  (st) => SubTipoActividad.fromJson(st as Map<String, dynamic>))
              .toList();
          return TipoActividad(
            id: json['Id'] as int,
            nombre: json['Nombre'] as String,
            subTipos: subTipos,
          );
        }).toList();
        return RespuestaBase(codigoRespuesta: codigo, respuesta: tipos);
      } else {
        return RespuestaBase(
          codigoRespuesta: codigo,
          mensajeError:
              data['MensajeError']?.toString() ?? 'Error al obtener tipos de actividad',
        );
      }
    } else {
      return RespuestaBase(
        codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
        mensajeError:
            'Error al obtener tipos de actividad: ${response.statusCode}',
      );
    }
  }
}
