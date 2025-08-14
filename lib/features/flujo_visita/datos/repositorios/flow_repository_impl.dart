import '../../dominio/entidades/descripcion_actividad_verificada.dart';
import '../../dominio/entidades/evaluacion.dart';
import '../../dominio/entidades/estimacion.dart';
import '../../dominio/entidades/registro_fotografico.dart';
import '../../dominio/entidades/completar_visita_comando.dart';
import '../../dominio/repositorios/flow_repository.dart';
import '../fuentes_datos/verificacion_remote_data_source.dart';

/// Implementación en memoria de [FlowRepository].
class FlowRepositoryImpl implements FlowRepository {
  FlowRepositoryImpl(this._verificacionRemoteDataSource);

  final VerificacionRemoteDataSource _verificacionRemoteDataSource;

  DescripcionActividadVerificada? _descripcion;
  Evaluacion? _evaluacion;
  Estimacion? _estimacion;
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
  Future<void> guardarEvaluacion(Evaluacion evaluacion) async {
    _evaluacion = evaluacion;
  }

  @override
  Future<Evaluacion?> obtenerEvaluacion() async {
    return _evaluacion;
  }

  @override
  Future<void> guardarEstimacion(Estimacion estimacion) async {
    _estimacion = estimacion;
  }

  @override
  Future<Estimacion?> obtenerEstimacion() async {
    return _estimacion;
  }

  @override
  Future<void> agregarFotoVerificacion(RegistroFotografico foto) async {
    _fotos.add(foto);
  }

  @override
  Future<void> eliminarFotoVerificacion(int index) async {
    _fotos.removeAt(index);
  }

  @override
  Future<List<RegistroFotografico>> obtenerFotosVerificacion() async {
    return List.unmodifiable(_fotos);
  }

  @override
  Future<void> completarFlujo(CompletarVisitaComando comando) async {
    await _verificacionRemoteDataSource.actualizarVerificacion(comando);
  }
}

