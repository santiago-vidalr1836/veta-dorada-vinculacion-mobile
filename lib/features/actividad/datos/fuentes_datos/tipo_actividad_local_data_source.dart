import 'package:sqflite/sqflite.dart';

import 'package:veta_dorada_vinculacion_mobile/core/servicios/servicio_bd_local.dart';

import '../../dominio/entidades/tipo_actividad.dart';

/// Fuente de datos local para almacenar tipos de actividad.
class TipoActividadLocalDataSource {
  TipoActividadLocalDataSource(this._bdLocal);

  final ServicioBdLocal _bdLocal;

  static const String _tabla = ServicioBdLocal.nombreTablaTipoActividad;

  /// Reemplaza los tipos de actividad almacenados por [tipos].
  Future<void> reemplazarTiposActividad(List<TipoActividad> tipos) async {
    try {
      await _bdLocal.delete(_tabla);
      for (final tipo in tipos) {
        await _bdLocal.insert(_tabla, {
          'id': tipo.id,
          'descripcion': tipo.descripcion,
        });
      }
    } on DatabaseException catch (e) {
      throw TipoActividadLocalException(
          'Error al guardar tipos de actividad: $e');
    }
  }

  /// Obtiene los tipos de actividad almacenados localmente.
  Future<List<TipoActividad>> obtenerTiposActividad() async {
    try {
      final rows = await _bdLocal.query(_tabla);
      return rows
          .map((row) => TipoActividad(
                id: row['id'] as int,
                descripcion: row['descripcion'] as String,
              ))
          .toList();
    } on DatabaseException catch (e) {
      throw TipoActividadLocalException(
          'Error al obtener tipos de actividad: $e');
    }
  }
}

/// Excepción para errores de acceso a los datos locales de tipos de actividad.
class TipoActividadLocalException implements Exception {
  TipoActividadLocalException(this.message);
  final String message;
  @override
  String toString() => 'TipoActividadLocalException: $message';
}
