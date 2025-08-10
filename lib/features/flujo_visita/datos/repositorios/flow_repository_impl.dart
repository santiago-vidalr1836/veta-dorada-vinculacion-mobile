import '../../dominio/entidades/descripcion_actividad_verificada.dart';
import '../../dominio/entidades/registro_fotografico.dart';
import '../../dominio/repositorios/flow_repository.dart';

/// Implementación en memoria de [FlowRepository].
class FlowRepositoryImpl implements FlowRepository {
  DescripcionActividadVerificada? _descripcion;
  final List<RegistroFotografico> _fotos = [];

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

  @override
  Future<void> agregarFotoVerificacion(RegistroFotografico foto) async {
    _fotos.add(foto);
  }

  @override
  Future<List<RegistroFotografico>> obtenerFotosVerificacion() async {
    return List.unmodifiable(_fotos);
  }
}

