import 'dart:convert';

import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';

import '../../dominio/entidades/inicio_proceso_formalizacion.dart';
import '../../dominio/entidades/tipo_proveedor.dart';
import '../../dominio/entidades/condicion_prospecto.dart';

/// Fuente de datos remota para obtener listas generales necesarias
/// durante el flujo de visita.
class GeneralRemoteDataSource {
  GeneralRemoteDataSource(this._client);

  final ClienteHttp _client;

  /// Obtiene los tipos de proveedor disponibles.
  Future<RespuestaBase<List<TipoProveedor>>> obtenerTiposProveedor() async {
    final uri =
        Uri.parse('${EnvironmentConfig.apiBaseUrl}/api/general/tipo/tipo-proveedor');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final codigo =
          data['CodigoRespuesta'] as int? ?? RespuestaBase.RESPUESTA_ERROR;
      if (codigo == RespuestaBase.RESPUESTA_CORRECTA &&
          data['Respuesta'] is List) {
        final tipos = (data['Respuesta'] as List<dynamic>)
            .map((e) => TipoProveedor.fromJson(e as Map<String, dynamic>))
            .toList();
        return RespuestaBase(codigoRespuesta: codigo, respuesta: tipos);
      } else {
        return RespuestaBase(
          codigoRespuesta: codigo,
          mensajeError: data['MensajeError']?.toString() ??
              'Error al obtener tipos de proveedor',
        );
      }
    } else {
      return RespuestaBase(
        codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
        mensajeError:
            'Error al obtener tipos de proveedor: ${response.statusCode}',
      );
    }
  }

  /// Obtiene los inicios de proceso de formalización.
  Future<RespuestaBase<List<InicioProcesoFormalizacion>>>
      obtenerIniciosProcesoFormalizacion() async {
    final uri = Uri.parse(
        '${EnvironmentConfig.apiBaseUrl}/api/general/tipo/inicio-proceso-formalizacion');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final codigo =
          data['CodigoRespuesta'] as int? ?? RespuestaBase.RESPUESTA_ERROR;
      if (codigo == RespuestaBase.RESPUESTA_CORRECTA &&
          data['Respuesta'] is List) {
        final inicios = (data['Respuesta'] as List<dynamic>)
            .map((e) =>
                InicioProcesoFormalizacion.fromJson(e as Map<String, dynamic>))
            .toList();
        return RespuestaBase(codigoRespuesta: codigo, respuesta: inicios);
      } else {
        return RespuestaBase(
          codigoRespuesta: codigo,
          mensajeError: data['MensajeError']?.toString() ??
              'Error al obtener inicios de formalización',
        );
      }
    } else {
      return RespuestaBase(
        codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
        mensajeError:
            'Error al obtener inicios de formalización: ${response.statusCode}',
      );
    }
  }

  /// Obtiene las condiciones del prospecto para verificación.
  Future<RespuestaBase<List<CondicionProspecto>>>
      obtenerCondicionesProspectoVerificacion() async {
    final uri = Uri.parse(
        '${EnvironmentConfig.apiBaseUrl}/api/general/tipo/condicion-prospecto-verificacion');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final codigo =
          data['CodigoRespuesta'] as int? ?? RespuestaBase.RESPUESTA_ERROR;
      if (codigo == RespuestaBase.RESPUESTA_CORRECTA &&
          data['Respuesta'] is List) {
        final condiciones = (data['Respuesta'] as List<dynamic>)
            .map((e) =>
                CondicionProspecto.fromJson(e as Map<String, dynamic>))
            .toList();
        return RespuestaBase(
            codigoRespuesta: codigo, respuesta: condiciones);
      } else {
        return RespuestaBase(
          codigoRespuesta: codigo,
          mensajeError: data['MensajeError']?.toString() ??
              'Error al obtener condiciones del prospecto',
        );
      }
    } else {
      return RespuestaBase(
        codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
        mensajeError:
            'Error al obtener condiciones del prospecto: ${response.statusCode}',
      );
    }
  }
}
