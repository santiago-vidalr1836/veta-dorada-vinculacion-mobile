import 'package:sqflite/sqflite.dart';

import 'package:veta_dorada_vinculacion_mobile/core/servicios/servicio_bd_local.dart';

import '../../dominio/entidades/inicio_proceso_formalizacion.dart';
import '../../dominio/entidades/tipo_proveedor.dart';

/// Fuente de datos local para almacenar y recuperar listas generales.
class GeneralLocalDataSource {
  GeneralLocalDataSource(this._bdLocal);

  final ServicioBdLocal _bdLocal;

  static const String _tablaTiposProveedor = 'tipos_proveedor';
  static const String _tablaIniciosFormalizacion =
      'inicios_proceso_formalizacion';

  Future<void> _crearTablasSiNoExisten() async {
    final db = await _bdLocal.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tablaTiposProveedor(
        id TEXT PRIMARY KEY,
        descripcion TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tablaIniciosFormalizacion(
        id TEXT PRIMARY KEY,
        descripcion TEXT
      );
    ''');
  }

  /// Reemplaza los tipos de proveedor almacenados.
  Future<void> reemplazarTiposProveedor(List<TipoProveedor> tipos) async {
    try {
      await _crearTablasSiNoExisten();
      final db = await _bdLocal.database;
      await db.delete(_tablaTiposProveedor);
      for (final tipo in tipos) {
        await _bdLocal.insert(_tablaTiposProveedor, {
          'id': tipo.id,
          'descripcion': tipo.descripcion,
        });
      }
    } on DatabaseException catch (e) {
      throw GeneralLocalException('Error al guardar tipos proveedor: $e');
    }
  }

  /// Obtiene los tipos de proveedor almacenados localmente.
  Future<List<TipoProveedor>> obtenerTiposProveedor() async {
    try {
      await _crearTablasSiNoExisten();
      final rows = await _bdLocal.query(_tablaTiposProveedor);
      return rows
          .map((row) =>
              TipoProveedor(id: row['id'] as String, descripcion: row['descripcion'] as String))
          .toList();
    } on DatabaseException catch (e) {
      throw GeneralLocalException('Error al obtener tipos proveedor: $e');
    }
  }

  /// Reemplaza los inicios de proceso de formalización almacenados.
  Future<void> reemplazarIniciosFormalizacion(
      List<InicioProcesoFormalizacion> inicios) async {
    try {
      await _crearTablasSiNoExisten();
      final db = await _bdLocal.database;
      await db.delete(_tablaIniciosFormalizacion);
      for (final inicio in inicios) {
        await _bdLocal.insert(_tablaIniciosFormalizacion, {
          'id': inicio.id,
          'descripcion': inicio.descripcion,
        });
      }
    } on DatabaseException catch (e) {
      throw GeneralLocalException('Error al guardar inicios formalización: $e');
    }
  }

  /// Obtiene los inicios de proceso de formalización almacenados.
  Future<List<InicioProcesoFormalizacion>> obtenerIniciosFormalizacion() async {
    try {
      await _crearTablasSiNoExisten();
      final rows = await _bdLocal.query(_tablaIniciosFormalizacion);
      return rows
          .map((row) => InicioProcesoFormalizacion(
                id: row['id'] as String,
                descripcion: row['descripcion'] as String,
              ))
          .toList();
    } on DatabaseException catch (e) {
      throw GeneralLocalException(
          'Error al obtener inicios formalización: $e');
    }
  }
}

/// Excepción para errores de acceso a datos locales generales.
class GeneralLocalException implements Exception {
  GeneralLocalException(this.message);
  final String message;
  @override
  String toString() => 'GeneralLocalException: $message';
}
