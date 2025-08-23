import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';

import '../../dominio/entidades/visita.dart';
import '../../dominio/repositorios/visits_repository.dart';
import '../fuentes_datos/visits_local_data_source.dart';
import '../fuentes_datos/visits_remote_data_source.dart';

/// Implementación de [VisitsRepository] que combina fuentes remotas y locales.
class VisitsRepositoryImpl implements VisitsRepository {
  VisitsRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final VisitsRemoteDataSource _remoteDataSource;
  final VisitsLocalDataSource _localDataSource;

  @override
  Future<({Map<String, List<Visita>> visitas, String? advertencia})>
      obtenerVisitasPorGeologo(int id) async {
    final respuesta = await _remoteDataSource.obtenerVisitas(id);
    if (respuesta.codigoRespuesta == RespuestaBase.RESPUESTA_CORRECTA &&
        respuesta.respuesta != null) {
      final remotas = respuesta.respuesta!;
      await _localDataSource.insertVisits(remotas);
      final Map<String, List<Visita>> agrupadas = {};
      for (final visita in remotas) {
        agrupadas.putIfAbsent(visita.id.toString(), () => []).add(visita);
      }
      return (visitas: agrupadas, advertencia: null);
    } else {
      final locales = await _localDataSource.getVisitsGroupedByState();
      final Map<String, List<Visita>> agrupadas = {};
      locales.forEach((estado, visitas) {
        agrupadas[estado] = visitas.cast<Visita>();
      });
      return (
        visitas: agrupadas,
        advertencia: respuesta.mensajeError,
      );
    }
  }
}
