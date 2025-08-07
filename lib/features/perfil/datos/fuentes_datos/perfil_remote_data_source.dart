import 'dart:convert';

import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';

import '../modelos/usuario.dart';

/// Fuente de datos remota que obtiene el perfil del usuario desde la API.
class PerfilRemoteDataSource {
  PerfilRemoteDataSource(this._client);

  final ClienteHttp _client;

  /// Realiza una solicitud GET a `/api/perfil` y devuelve un [Usuario].
  Future<Usuario> obtenerPerfil() async {
    final uri = Uri.parse('${EnvironmentConfig.apiBaseUrl}/api/perfil');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw PerfilRemoteException(
        'Error al obtener el perfil: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return Usuario.fromJson(data);
  }
}

/// Excepción que se lanza cuando ocurre un error al obtener el perfil.
class PerfilRemoteException implements Exception {
  PerfilRemoteException(this.message);

  final String message;

  @override
  String toString() => 'PerfilRemoteException: $message';
}

