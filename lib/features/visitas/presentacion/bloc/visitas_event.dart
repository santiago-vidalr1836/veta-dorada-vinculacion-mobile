abstract class VisitasEvent {}

class CargarVisitas extends VisitasEvent {
  CargarVisitas(this.idGeologo);
  final int idGeologo;
}

class SincronizarVisitas extends VisitasEvent {
  SincronizarVisitas(this.idGeologo);
  final int idGeologo;
}
