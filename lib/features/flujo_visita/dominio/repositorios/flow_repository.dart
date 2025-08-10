import '../entidades/descripcion_actividad_verificada.dart';
import '../entidades/registro_fotografico.dart';

/// Repositorio para manejar los datos del flujo de visita.
abstract class FlowRepository {
  /// Guarda la descripción de la actividad verificada.
  Future<void> guardarDescripcionActividadVerificada(
      DescripcionActividadVerificada descripcion);

  /// Recupera la descripción de la actividad verificada almacenada.
  Future<DescripcionActividadVerificada?>
      obtenerDescripcionActividadVerificada();

  /// Agrega un registro fotográfico de la verificación.
  Future<void> agregarFotoVerificacion(RegistroFotografico foto);

  /// Obtiene la lista de registros fotográficos agregados.
  Future<List<RegistroFotografico>> obtenerFotosVerificacion();
}

