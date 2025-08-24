import 'entidades/realizar_verificacion_dto.dart';

/// Número total de pasos del flujo de verificación.
const int totalPasosVerificacion = 9;

/// Calcula el avance del flujo de verificación basado en el
/// contenido del [dto]. Retorna un valor entre 0 y 1.
double calcularAvance(RealizarVerificacionDto dto) {
  var count = 0;
  if (dto.fechaInicioMovil != null) count++;
  if (dto.actividades != null && dto.actividades!.isNotEmpty) {
    count += dto.actividades!.length.clamp(0, 3);
  }
  if (dto.descripcion != null) count++;
  if (dto.evaluacion != null) count++;
  if (dto.estimacion != null) count++;
  if (dto.fotos != null && dto.fotos!.isNotEmpty) count++;
  if (dto.proveedorSnapshot != null) count++;

  return count / totalPasosVerificacion;
}
