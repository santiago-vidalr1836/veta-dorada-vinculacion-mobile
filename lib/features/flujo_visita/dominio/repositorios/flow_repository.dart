import '../entidades/descripcion_actividad_verificada.dart';

/// Repositorio para manejar los datos del flujo de visita.
abstract class FlowRepository {
  /// Guarda la descripción de la actividad verificada.
  Future<void> guardarDescripcionActividadVerificada(
      DescripcionActividadVerificada descripcion);

  /// Recupera la descripción de la actividad verificada almacenada.
  Future<DescripcionActividadVerificada?>
      obtenerDescripcionActividadVerificada();
}

