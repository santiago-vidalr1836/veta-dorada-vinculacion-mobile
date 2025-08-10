import '../entidades/registro_fotografico.dart';
import '../repositorios/flow_repository.dart';

/// Caso de uso para agregar un registro fotográfico de la verificación.
class AgregarFotoVerificacion {
  AgregarFotoVerificacion(this._repositorio);

  final FlowRepository _repositorio;

  Future<void> call(RegistroFotografico foto) =>
      _repositorio.agregarFotoVerificacion(foto);
}

/// Caso de uso para obtener todos los registros fotográficos agregados.
class ObtenerFotosVerificacion {
  ObtenerFotosVerificacion(this._repositorio);

  final FlowRepository _repositorio;

  Future<List<RegistroFotografico>> call() =>
      _repositorio.obtenerFotosVerificacion();
}

