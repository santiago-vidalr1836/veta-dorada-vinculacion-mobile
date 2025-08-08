import 'dart:convert';

import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';

import '../modelos/visita_model.dart';

/// Fuente de datos remota que obtiene las visitas desde la API.
class VisitsRemoteDataSource {
  VisitsRemoteDataSource(this._client);

  final ClienteHttp _client;

  /// Obtiene las visitas del geólogo identificado por [idGeologo].
  ///
  /// Realiza una solicitud GET a `/api/geologos/{idGeologo}/visitas` y
  /// devuelve una [RespuestaBase] con la lista de [VisitaModel].
  Future<RespuestaBase<List<VisitaModel>>> obtenerVisitas(
      String idGeologo) async {
    final uri = Uri.parse(
      '${EnvironmentConfig.apiBaseUrl}/api/geologos/$idGeologo/visitas',
    );
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      final visitas = data
          .map((json) => VisitaModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return RespuestaBase.respuestaCorrecta(visitas);
    } else {
      return RespuestaBase.respuestaError(
        'Error al obtener visitas: ${response.statusCode}',
      );
    }
  }
}
