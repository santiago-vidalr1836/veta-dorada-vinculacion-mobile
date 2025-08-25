import 'package:sqflite/sqflite.dart';

import 'package:veta_dorada_vinculacion_mobile/core/servicios/servicio_bd_local.dart';

import '../../dominio/entidades/tipo_actividad.dart';

/// Fuente de datos local para almacenar tipos de actividad.
class TipoActividadLocalDataSource {
  TipoActividadLocalDataSource(this._bdLocal);

  final ServicioBdLocal _bdLocal;

  static const String _tabla = ServicioBdLocal.nombreTablaTipoActividad;
  static const String _tablaSub = ServicioBdLocal.nombreTablaSubTipoActividad;

  /// Reemplaza los tipos de actividad almacenados por [tipos].
  Future<void> reemplazarTiposActividad(List<TipoActividad> tipos) async {
    try {
      await _bdLocal.delete(_tablaSub);
      await _bdLocal.delete(_tabla);
      for (final tipo in tipos) {
        await _bdLocal.insert(_tabla, {
          'id': tipo.id,
          'nombre': tipo.nombre,
        });
        for (final sub in tipo.subTipos) {
          await _bdLocal.insert(_tablaSub, {
            'id': sub.id,
            'nombre': sub.nombre,
            'tipoActividadId': tipo.id,
          });
        }
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
      final subRows = await _bdLocal.query(_tablaSub);
      final Map<int, List<SubTipoActividad>> subMap = {};
      for (final row in subRows) {
        final tipoId = row['tipoActividadId'] as int;
        subMap.putIfAbsent(tipoId, () => []).add(SubTipoActividad(
              id: row['id'] as int,
              nombre: row['nombre'] as String,
            ));
      }
      return rows
          .map((row) => TipoActividad(
                id: row['id'] as int,
                nombre: row['nombre'] as String,
                subTipos: subMap[row['id'] as int] ?? const [],
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
