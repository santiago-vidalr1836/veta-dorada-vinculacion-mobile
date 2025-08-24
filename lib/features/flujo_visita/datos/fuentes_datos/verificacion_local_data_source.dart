import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../../core/servicios/servicio_bd_local.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';

/// Fuente de datos local para almacenar la información de verificación.
class VerificacionLocalDataSource {
  VerificacionLocalDataSource(this._bdLocal);

  final ServicioBdLocal _bdLocal;

  static const String _tabla =
      ServicioBdLocal.nombreTablaRealizarVerificacion;

  /// Inserta o actualiza una verificación.
  Future<void> upsertVerificacion(RealizarVerificacionDto dto) async {
    try {
      await _bdLocal.insert(_tabla, {
        'idVisita': dto.idVisita.toString(),
        'data': jsonEncode(dto.toJson()),
      });
    } on DatabaseException catch (e) {
      throw VerificacionLocalException(
          'Error al guardar verificación: $e');
    }
  }

  /// Obtiene la verificación almacenada para [idVisita].
  Future<RealizarVerificacionDto?> obtenerVerificacion(int idVisita) async {
    try {
      final rows = await _bdLocal.query(
        _tabla,
        where: 'idVisita = ?',
        whereArgs: [idVisita.toString()],
      );
      if (rows.isEmpty) return null;
      final data =
          jsonDecode(rows.first['data'] as String) as Map<String, dynamic>;
      return RealizarVerificacionDto.fromJson(data);
    } on DatabaseException catch (e) {
      throw VerificacionLocalException(
          'Error al obtener verificación: $e');
    }
  }

  /// Obtiene los identificadores de visitas que tienen una verificación
  /// almacenada.
  Future<List<int>> obtenerVisitasConVerificacion() async {
    try {
      final rows = await _bdLocal.query(_tabla, columns: ['idVisita']);
      return rows
          .map((row) => int.parse(row['idVisita'] as String))
          .toList();
    } on DatabaseException catch (e) {
      throw VerificacionLocalException(
          'Error al obtener verificaciones: $e');
    }
  }
}

/// Excepción lanzada para errores de acceso a datos de verificación local.
class VerificacionLocalException implements Exception {
  VerificacionLocalException(this.message);
  final String message;
  @override
  String toString() => 'VerificacionLocalException: $message';
}

