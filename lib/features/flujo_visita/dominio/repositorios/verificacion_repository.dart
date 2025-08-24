import '../entidades/realizar_verificacion_dto.dart';

/// Repositorio para gestionar la información de verificación de visitas.
abstract class VerificacionRepository {
  /// Guarda localmente la información de la verificación.
  Future<void> guardarVerificacion(RealizarVerificacionDto dto);

  /// Obtiene la información de verificación almacenada para [idVisita].
  Future<RealizarVerificacionDto?> obtenerVerificacion(int idVisita);
}

