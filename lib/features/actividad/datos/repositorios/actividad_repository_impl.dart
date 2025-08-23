import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';

import '../../dominio/entidades/tipo_actividad.dart';
import '../fuentes_datos/tipo_actividad_local_data_source.dart';
import '../fuentes_datos/tipo_actividad_remote_data_source.dart';

/// Implementación del repositorio de actividades.
class ActividadRepositoryImpl {
  ActividadRepositoryImpl(
      this._remoteDataSource, this._localDataSource);

  final TipoActividadRemoteDataSource _remoteDataSource;
  final TipoActividadLocalDataSource _localDataSource;

  /// Sincroniza los tipos de actividad descargándolos desde la API y
  /// almacenándolos localmente.
  Future<void> sincronizarTiposActividad() async {
    final respuesta = await _remoteDataSource.obtenerTiposActividad();
    if (respuesta.codigoRespuesta == RespuestaBase.RESPUESTA_CORRECTA &&
        respuesta.respuesta != null) {
      await _localDataSource.reemplazarTiposActividad(respuesta.respuesta!);
    } else {
      await _localDataSource.reemplazarTiposActividad(const []);
    }
  }

  /// Obtiene los tipos de actividad, intentando primero desde la API.
  ///
  /// Si la solicitud remota falla, devuelve los datos locales y un mensaje
  /// de advertencia con la causa del fallo.
  Future<({List<TipoActividad> tipos, String? advertencia})>
      obtenerTiposActividad() async {
    final respuesta = await _remoteDataSource.obtenerTiposActividad();
    if (respuesta.codigoRespuesta == RespuestaBase.RESPUESTA_CORRECTA &&
        respuesta.respuesta != null) {
      await _localDataSource.reemplazarTiposActividad(respuesta.respuesta!);
      return (tipos: respuesta.respuesta!, advertencia: null);
    } else {
      final locales = await _localDataSource.obtenerTiposActividad();
      return (tipos: locales, advertencia: respuesta.mensajeError);
    }
  }
}
