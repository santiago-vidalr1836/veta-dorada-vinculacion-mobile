import '../entidades/descripcion_actividad_verificada.dart';
import '../repositorios/flow_repository.dart';

/// Caso de uso para guardar la descripción de la actividad verificada.
class GuardarDescripcionActividadVerificada {
  GuardarDescripcionActividadVerificada(this._repositorio);

  final FlowRepository _repositorio;

  Future<void> call(DescripcionActividadVerificada descripcion) =>
      _repositorio.guardarDescripcionActividadVerificada(descripcion);
}

/// Caso de uso para obtener la descripción de la actividad verificada.
class ObtenerDescripcionActividadVerificada {
  ObtenerDescripcionActividadVerificada(this._repositorio);

  final FlowRepository _repositorio;

  Future<DescripcionActividadVerificada?> call() =>
      _repositorio.obtenerDescripcionActividadVerificada();
}

