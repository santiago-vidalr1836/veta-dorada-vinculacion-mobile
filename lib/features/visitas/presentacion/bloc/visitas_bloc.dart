import 'package:bloc/bloc.dart';

import '../../datos/fuentes_datos/visits_local_data_source.dart'
    show VisitsLocalException;
import '../../dominio/entidades/general.dart';
import '../../dominio/entidades/visita.dart';
import '../../dominio/repositorios/visits_repository.dart';

part 'visitas_event.dart';
part 'visitas_state.dart';

class VisitasBloc extends Bloc<VisitasEvent, VisitasState> {
  VisitasBloc(this._repository) : super(VisitasCargando()) {
    on<CargarVisitas>(_onCargarVisitas);
    on<SincronizarVisitas>(_onSincronizarVisitas);
  }

  final VisitsRepository _repository;

  Future<void> _onCargarVisitas(
    CargarVisitas event,
    Emitter<VisitasState> emit,
  ) async {
    emit(VisitasCargando());
    try {
      final resultado =
          await _repository.obtenerVisitasPorGeologo(event.idGeologo);
      final programadas =
          resultado.visitas[General.ESTADO_VISITA_PROGRAMADA] ?? [];
      final borrador =
          resultado.visitas[General.ESTADO_VISITA_EN_PROCESO] ?? [];
      final completadas =
          resultado.visitas[General.ESTADO_VISITA_FINALIZADA] ?? [];
      emit(VisitasCargadas(
        programadas: programadas,
        borrador: borrador,
        completadas: completadas,
        advertencia: resultado.advertencia,
      ));
    } on VisitsLocalException catch (e) {
      emit(VisitasError(e.message));
    } catch (e) {
      emit(VisitasError(e.toString()));
    }
  }

  Future<void> _onSincronizarVisitas(
    SincronizarVisitas event,
    Emitter<VisitasState> emit,
  ) async {
    await _onCargarVisitas(CargarVisitas(event.idGeologo), emit);
  }
}
