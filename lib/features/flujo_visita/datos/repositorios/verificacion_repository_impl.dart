import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/repositorios/verificacion_repository.dart';
import '../fuentes_datos/verificacion_local_data_source.dart';

/// Implementación de [VerificacionRepository] que utiliza una fuente de datos
/// local para persistir la información de la verificación.
class VerificacionRepositoryImpl implements VerificacionRepository {
  VerificacionRepositoryImpl(this._localDataSource);

  final VerificacionLocalDataSource _localDataSource;

  @override
  Future<void> guardarVerificacion(RealizarVerificacionDto dto) async {
    await _localDataSource.upsertVerificacion(dto);
  }

  @override
  Future<RealizarVerificacionDto?> obtenerVerificacion(int idVisita) async {
    return _localDataSource.obtenerVerificacion(idVisita);
  }
}

