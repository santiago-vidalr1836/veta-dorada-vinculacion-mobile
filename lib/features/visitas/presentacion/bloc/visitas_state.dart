part of 'visitas_bloc.dart';

abstract class VisitasState {}

class VisitasCargando extends VisitasState {}

class VisitasCargadas extends VisitasState {
  VisitasCargadas({
    required this.programadas,
    required this.borrador,
    required this.completadas,
    this.advertencia,
  });

  final List<Visita> programadas;
  final List<Visita> borrador;
  final List<Visita> completadas;
  final String? advertencia;
}

class VisitasError extends VisitasState {
  VisitasError(this.mensaje);
  final String mensaje;
}
