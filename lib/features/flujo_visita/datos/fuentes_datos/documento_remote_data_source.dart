import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/config/environment_config.dart';
import '../../../../core/red/cliente_http.dart';

/// Fuente de datos remota para subir documentos asociados a la visita.
class DocumentoRemoteDataSource {
  DocumentoRemoteDataSource(this._client);

  final ClienteHttp _client;

  /// Sube una fotografía al servidor y devuelve la URL pública.
  ///
  /// El archivo se envía mediante `multipart/form-data` utilizando
  /// [ClienteHttp] para inyectar la autenticación necesaria.
  Future<String> subirDocumento(File foto) async {
    final uri = Uri.parse('${EnvironmentConfig.apiBaseUrl}/api/documentos');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('archivo', foto.path));

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return data['url']?.toString() ?? '';
    } else {
      throw Exception('Error al subir documento: ${response.statusCode}');
    }
  }
}

