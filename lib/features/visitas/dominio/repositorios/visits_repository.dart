import '../entidades/visita.dart';

/// Contrato para el acceso a visitas.
abstract class VisitsRepository {
  /// Obtiene las visitas del geólogo identificado por [id] agrupadas por estado.
  ///
  /// Retorna un registro con las listas y un [advertencia] cuando la
  /// sincronización remota falla y se usan datos locales.
  Future<({Map<String, List<Visita>> visitas, String? advertencia})>
      obtenerVisitasPorGeologo(int id);
}
