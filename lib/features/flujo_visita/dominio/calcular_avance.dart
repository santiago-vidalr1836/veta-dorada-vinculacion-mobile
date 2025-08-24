import 'entidades/realizar_verificacion_dto.dart';

/// Número total de pasos del flujo de verificación.
const int totalPasosVerificacion = 9;

/// Calcula el avance del flujo de verificación basado en el
/// contenido del [dto]. Retorna un valor entre 0 y 1.
double calcularAvance(RealizarVerificacionDto dto) {
  var count = 0;
  if (dto.actividades!=null && dto.actividades!.isNotEmpty && dto.actividades!.length<=3){
    count+= dto.actividades!.length;
  }
  if (dto.descripcion!=null && (
      dto.descripcion!.coordenadas.isNotEmpty ||
      dto.descripcion!.zona.isNotEmpty ||
      dto.descripcion!.actividad.isNotEmpty ||
      dto.descripcion!.equipos.isNotEmpty ||
      dto.descripcion!.trabajadores.isNotEmpty ||
      dto.descripcion!.condicionesLaborales.isNotEmpty)) {
    count++;
  }
  if (dto.evaluacion!= null && (
      dto.evaluacion!.idCondicionProspecto.isNotEmpty ||
      (dto.evaluacion!.anotacion?.isNotEmpty ?? false))) {
    count++;
  }
  if ( dto.estimacion!=null && (
      dto.estimacion!.longitudAvance > 0 ||
      dto.estimacion!.alturaFrente > 0 ||
      dto.estimacion!.espesorVeta > 0 ||
      dto.estimacion!.numeroDisparosDia > 0 ||
      dto.estimacion!.diasTrabajados > 0 ||
      dto.estimacion!.porcentajeRocaCaja > 0 ||
      dto.estimacion!.produccionDiariaEstimada > 0 ||
      dto.estimacion!.produccionMensualEstimada > 0 ||
      dto.estimacion!.produccionMensual > 0)) {
    count++;
  }
  if (dto.fotos!=null && dto.fotos!.isNotEmpty) count++;
  if (dto.proveedorSnapshot!=null && dto.proveedorSnapshot!.nombre.isNotEmpty) count++;

  return count / totalPasosVerificacion;
}
