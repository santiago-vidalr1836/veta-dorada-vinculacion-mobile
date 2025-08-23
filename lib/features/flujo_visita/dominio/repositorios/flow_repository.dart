import '../entidades/descripcion_actividad_verificada.dart';
import '../entidades/evaluacion.dart';
import '../entidades/estimacion.dart';
import '../entidades/registro_fotografico.dart';
import '../entidades/completar_visita_comando.dart';

/// Repositorio para manejar los datos del flujo de visita.
abstract class FlowRepository {
  /// Guarda la descripción de la actividad verificada.
  Future<void> guardarDescripcionActividadVerificada(
      DescripcionActividadVerificada descripcion);

  /// Recupera la descripción de la actividad verificada almacenada.
  Future<DescripcionActividadVerificada?>
      obtenerDescripcionActividadVerificada();

  /// Guarda la evaluación de la labor realizada.
  Future<void> guardarEvaluacion(Evaluacion evaluacion);

  /// Recupera la evaluación almacenada.
  Future<Evaluacion?> obtenerEvaluacion();

  /// Guarda la estimación de producción calculada.
  Future<void> guardarEstimacion(Estimacion estimacion);

  /// Recupera la estimación de producción almacenada.
  Future<Estimacion?> obtenerEstimacion();

  /// Agrega un registro fotográfico de la verificación.
  Future<void> agregarFotoVerificacion(RegistroFotografico foto);

  /// Elimina un registro fotográfico por índice.
  Future<void> eliminarFotoVerificacion(int index);

  /// Obtiene la lista de registros fotográficos agregados.
  Future<List<RegistroFotografico>> obtenerFotosVerificacion();

  /// Completa el flujo enviando la información recopilada al servidor.
  Future<void> completarFlujo(CompletarVisitaComando comando);
}

