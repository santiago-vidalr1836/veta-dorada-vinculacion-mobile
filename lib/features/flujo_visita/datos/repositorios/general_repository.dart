import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';

import '../../dominio/entidades/inicio_proceso_formalizacion.dart';
import '../../dominio/entidades/tipo_proveedor.dart';
import '../../dominio/entidades/condicion_prospecto.dart';
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

  /// Obtiene las condiciones del prospecto desde la API y las almacena localmente.
  Future<({List<CondicionProspecto> condiciones, String? advertencia})>
      obtenerCondicionesProspecto() async {
    final respuesta =
        await _remoteDataSource.obtenerCondicionesProspectoVerificacion();
    if (respuesta.codigoRespuesta == RespuestaBase.RESPUESTA_CORRECTA &&
        respuesta.respuesta != null) {
      await _localDataSource
          .reemplazarCondicionesProspecto(respuesta.respuesta!);
      return (condiciones: respuesta.respuesta!, advertencia: null);
    } else {
      final locales = await _localDataSource.obtenerCondicionesProspecto();
      return (condiciones: locales, advertencia: respuesta.mensajeError);
    }
  }

  /// Sincroniza los catálogos generales al inicio de la aplicación.
  ///
  /// Borra los datos existentes y descarga los registros más recientes desde
  /// el repositorio remoto para almacenarlos localmente.
  Future<void> sincronizarDatosGenerales() async {
    final tiposRespuesta = await _remoteDataSource.obtenerTiposProveedor();
    if (tiposRespuesta.codigoRespuesta ==
            RespuestaBase.RESPUESTA_CORRECTA &&
        tiposRespuesta.respuesta != null) {
      await _localDataSource.reemplazarTiposProveedor(
          tiposRespuesta.respuesta!);
    } else {
      await _localDataSource.reemplazarTiposProveedor(const []);
    }

    final iniciosRespuesta =
        await _remoteDataSource.obtenerIniciosProcesoFormalizacion();
    if (iniciosRespuesta.codigoRespuesta ==
            RespuestaBase.RESPUESTA_CORRECTA &&
        iniciosRespuesta.respuesta != null) {
      await _localDataSource
          .reemplazarIniciosFormalizacion(iniciosRespuesta.respuesta!);
    } else {
      await _localDataSource.reemplazarIniciosFormalizacion(const []);
    }

    final condicionesRespuesta =
        await _remoteDataSource.obtenerCondicionesProspectoVerificacion();
    if (condicionesRespuesta.codigoRespuesta ==
            RespuestaBase.RESPUESTA_CORRECTA &&
        condicionesRespuesta.respuesta != null) {
      await _localDataSource
          .reemplazarCondicionesProspecto(condicionesRespuesta.respuesta!);
    } else {
      await _localDataSource.reemplazarCondicionesProspecto(const []);
    }
  }
}
