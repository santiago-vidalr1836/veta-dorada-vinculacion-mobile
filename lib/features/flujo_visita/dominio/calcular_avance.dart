import 'entidades/realizar_verificacion_dto.dart';

/// Número total de pasos del flujo de verificación.
const int totalPasosVerificacion = 9;

/// Calcula el avance del flujo de verificación basado en el
/// contenido del [dto]. Retorna un valor entre 0 y 1.
double calcularAvance(RealizarVerificacionDto dto) {
  var count = 0;
  if (dto.actividades.isNotEmpty) count++;
  if (dto.descripcion.coordenadas.isNotEmpty ||
      dto.descripcion.zona.isNotEmpty ||
      dto.descripcion.actividad.isNotEmpty ||
      dto.descripcion.equipos.isNotEmpty ||
      dto.descripcion.trabajadores.isNotEmpty ||
      dto.descripcion.condicionesLaborales.isNotEmpty) {
    count++;
  }
  if (dto.evaluacion.idCondicionProspecto.isNotEmpty ||
      (dto.evaluacion.anotacion?.isNotEmpty ?? false)) {
    count++;
  }
  if (dto.estimacion.capacidadDiaria > 0 ||
      dto.estimacion.diasOperacion > 0 ||
      dto.estimacion.produccionEstimada > 0) {
    count++;
  }
  if (dto.fotos.isNotEmpty) count++;
  if (dto.proveedorSnapshot.nombre.isNotEmpty) count++;

  return count / totalPasosVerificacion;
}
