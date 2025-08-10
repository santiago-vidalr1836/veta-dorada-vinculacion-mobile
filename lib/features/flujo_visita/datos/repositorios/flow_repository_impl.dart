import '../../dominio/entidades/descripcion_actividad_verificada.dart';
import '../../dominio/repositorios/flow_repository.dart';

/// Implementación en memoria de [FlowRepository].
class FlowRepositoryImpl implements FlowRepository {
  DescripcionActividadVerificada? _descripcion;

  @override
  Future<void> guardarDescripcionActividadVerificada(
      DescripcionActividadVerificada descripcion) async {
    _descripcion = descripcion;
  }

  @override
  Future<DescripcionActividadVerificada?>
      obtenerDescripcionActividadVerificada() async {
    return _descripcion;
  }
}

