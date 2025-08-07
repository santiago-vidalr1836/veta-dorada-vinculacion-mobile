import 'dart:convert';

import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';

import '../modelos/visita_model.dart';

/// Fuente de datos remota que obtiene las visitas desde la API.
class VisitsRemoteDataSource {
  VisitsRemoteDataSource(this._client);

  final ClienteHttp _client;

  /// Obtiene las visitas del geólogo identificado por [idGeologo].
  ///
  /// Realiza una solicitud GET a `/api/geologos/{idGeologo}/visitas` y
  /// devuelve una lista de [VisitaModel].
  Future<List<VisitaModel>> obtenerVisitas(String idGeologo) async {
    final uri = Uri.parse(
      '${EnvironmentConfig.apiBaseUrl}/api/geologos/$idGeologo/visitas',
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw VisitsRemoteException(
        'Error al obtener visitas: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((json) => VisitaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

/// Excepción lanzada cuando ocurre un error al obtener las visitas.
class VisitsRemoteException implements Exception {
  VisitsRemoteException(this.message);

  final String message;

  @override
  String toString() => 'VisitsRemoteException: $message';
}

