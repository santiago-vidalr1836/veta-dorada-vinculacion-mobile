part of 'visitas_bloc.dart';

abstract class VisitasEvent {}

class CargarVisitas extends VisitasEvent {
  CargarVisitas(this.idGeologo);
  final String idGeologo;
}

class SincronizarVisitas extends VisitasEvent {
  SincronizarVisitas(this.idGeologo);
  final String idGeologo;
}
