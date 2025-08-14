import 'dart:convert';

import '../../../../core/config/environment_config.dart';
import '../../../../core/red/cliente_http.dart';
import '../../dominio/entidades/completar_visita_comando.dart';

/// Fuente de datos remota para actualizar la verificación de una visita.
class VerificacionRemoteDataSource {
  VerificacionRemoteDataSource(this._client);

  final ClienteHttp _client;

  /// Envía al servidor la información recopilada durante la visita.
  Future<void> actualizarVerificacion(CompletarVisitaComando comando) async {
    final uri = Uri.parse(
        '${EnvironmentConfig.apiBaseUrl}/api/visitas/${comando.idVisita}/verificacion');
    final response = await _client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(comando.toJson()),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Error al actualizar verificación: ${response.statusCode}');
    }
  }
}

