import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';

import '../../dominio/entidades/inicio_proceso_formalizacion.dart';
import '../../dominio/entidades/tipo_proveedor.dart';
import '../fuentes_datos/general_local_data_source.dart';
import '../fuentes_datos/general_remote_data_source.dart';

/// Repositorio que coordina la obtención y almacenamiento de datos generales
/// utilizados en el flujo de visita.
class GeneralRepository {
  GeneralRepository(this._remoteDataSource, this._localDataSource);

  final GeneralRemoteDataSource _remoteDataSource;
  final GeneralLocalDataSource _localDataSource;

  /// Obtiene los tipos de proveedor desde la API y los almacena localmente.
  ///
  /// Si la consulta remota falla, se intenta devolver los datos almacenados
  /// localmente y se incluye un mensaje de advertencia.
  Future<({List<TipoProveedor> tipos, String? advertencia})>
      obtenerTiposProveedor() async {
    final respuesta = await _remoteDataSource.obtenerTiposProveedor();
    if (respuesta.codigoRespuesta == RespuestaBase.RESPUESTA_CORRECTA &&
        respuesta.respuesta != null) {
      await _localDataSource.reemplazarTiposProveedor(respuesta.respuesta!);
      return (tipos: respuesta.respuesta!, advertencia: null);
    } else {
      final locales = await _localDataSource.obtenerTiposProveedor();
      return (tipos: locales, advertencia: respuesta.mensajeError);
    }
  }

  /// Obtiene los inicios de proceso de formalización desde la API y los
  /// almacena localmente.
  Future<({List<InicioProcesoFormalizacion> inicios, String? advertencia})>
      obtenerIniciosFormalizacion() async {
    final respuesta =
        await _remoteDataSource.obtenerIniciosProcesoFormalizacion();
    if (respuesta.codigoRespuesta == RespuestaBase.RESPUESTA_CORRECTA &&
        respuesta.respuesta != null) {
      await _localDataSource
          .reemplazarIniciosFormalizacion(respuesta.respuesta!);
      return (inicios: respuesta.respuesta!, advertencia: null);
    } else {
      final locales = await _localDataSource.obtenerIniciosFormalizacion();
      return (inicios: locales, advertencia: respuesta.mensajeError);
    }
  }
}
