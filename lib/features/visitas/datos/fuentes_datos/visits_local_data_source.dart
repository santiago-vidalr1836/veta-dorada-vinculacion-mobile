import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'package:veta_dorada_vinculacion_mobile/core/servicios/servicio_bd_local.dart';
import '../modelos/visita_model.dart';

/// Fuente de datos local que gestiona el almacenamiento de visitas en la
/// base de datos SQLite.
class VisitsLocalDataSource {
  VisitsLocalDataSource(this._bdLocal);

  final ServicioBdLocal _bdLocal;

  /// Inserta una lista de [visits] en la base de datos.
  Future<void> insertVisits(List<VisitaModel> visits) async {
    try {
      for (final visit in visits) {
        await _bdLocal.insert(ServicioBdLocal.nombreTablaVisitas, {
          'id': visit.id,
          'estado': visit.estado,
          'data': jsonEncode(visit.toJson()),
        });
      }
    } on DatabaseException catch (e) {
      throw VisitsLocalException('Error al insertar visitas: $e');
    }
  }

  /// Actualiza los datos de una [visit] existente.
  Future<void> updateVisit(VisitaModel visit) async {
    try {
      await _bdLocal.update(
        ServicioBdLocal.nombreTablaVisitas,
        {
          'estado': visit.estado,
          'data': jsonEncode(visit.toJson()),
        },
        where: 'id = ?',
        whereArgs: [visit.id],
      );
    } on DatabaseException catch (e) {
      throw VisitsLocalException('Error al actualizar visita: $e');
    }
  }

  /// Obtiene todas las visitas agrupadas por su estado.
  Future<Map<String, List<VisitaModel>>> getVisitsGroupedByState() async {
    try {
      final rows =
          await _bdLocal.query(ServicioBdLocal.nombreTablaVisitas);
      final Map<String, List<VisitaModel>> grouped = {};
      for (final row in rows) {
        final estado = row['estado'] as String;
        final data =
            jsonDecode(row['data'] as String) as Map<String, dynamic>;
        final visita = VisitaModel.fromJson(data);
        grouped.putIfAbsent(estado, () => []).add(visita);
      }
      return grouped;
    } on DatabaseException catch (e) {
      throw VisitsLocalException('Error al obtener visitas: $e');
    }
  }
}

/// Excepción lanzada cuando ocurre un problema de acceso a la base de datos
/// local de visitas.
class VisitsLocalException implements Exception {
  VisitsLocalException(this.message);
  final String message;
  @override
  String toString() => 'VisitsLocalException: $message';
}
