import 'package:bloc/bloc.dart';

import '../../datos/fuentes_datos/visits_local_data_source.dart'
    show VisitsLocalException;
import '../../dominio/entidades/estado_visita.dart';
import '../../dominio/entidades/visita.dart';
import '../../dominio/repositorios/visits_repository.dart';
import '../../../flujo_visita/dominio/repositorios/verificacion_repository.dart';

part 'visitas_event.dart';
part 'visitas_state.dart';

class VisitasBloc extends Bloc<VisitasEvent, VisitasState> {
  VisitasBloc(this._repository, this._verificacionRepository)
      : super(VisitasCargando()) {
    on<CargarVisitas>(_onCargarVisitas);
    on<SincronizarVisitas>(_onSincronizarVisitas);
  }

  final VisitsRepository _repository;
  final VerificacionRepository _verificacionRepository;

  Future<void> _onCargarVisitas(
    CargarVisitas event,
    Emitter<VisitasState> emit,
  ) async {
    emit(VisitasCargando());
    try {
      final resultado =
          await _repository.obtenerVisitasPorGeologo(event.idGeologo);

      final todasProgramadas =
          resultado.visitas[EstadoVisita.programada] ?? [];
      final completadas =
          resultado.visitas[EstadoVisita.realizada] ?? [];

      final programadas = <Visita>[];
      final borrador = <Visita>[];

      for (final visita in todasProgramadas) {
        final verificacion =
            await _verificacionRepository.obtenerVerificacion(visita.id);
        if (verificacion != null) {
          borrador.add(visita);
        } else {
          programadas.add(visita);
        }
      }

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
