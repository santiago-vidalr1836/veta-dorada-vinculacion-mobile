import 'package:sqflite/sqflite.dart';

import 'package:veta_dorada_vinculacion_mobile/core/servicios/servicio_bd_local.dart';

import '../../dominio/entidades/inicio_proceso_formalizacion.dart';
import '../../dominio/entidades/tipo_proveedor.dart';
import '../../dominio/entidades/condicion_prospecto.dart';

/// Fuente de datos local para almacenar y recuperar listas generales.
class GeneralLocalDataSource {
  GeneralLocalDataSource(this._bdLocal);

  final ServicioBdLocal _bdLocal;

  static const String _tablaTiposProveedor =
      ServicioBdLocal.nombreTablaTipoProveedor;
  static const String _tablaIniciosFormalizacion =
      ServicioBdLocal.nombreTablaInicioProcesoFormalizacion;
  static const String _tablaCondicionesProspecto =
      ServicioBdLocal.nombreTablaCondicionProspecto;

  /// Reemplaza los tipos de proveedor almacenados.
  Future<void> reemplazarTiposProveedor(List<TipoProveedor> tipos) async {
    try {
      await _bdLocal.delete(_tablaTiposProveedor);
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
      await _bdLocal.delete(_tablaIniciosFormalizacion);
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

  /// Reemplaza las condiciones del prospecto almacenadas.
  Future<void> reemplazarCondicionesProspecto(
      List<CondicionProspecto> condiciones) async {
    try {
      await _bdLocal.delete(_tablaCondicionesProspecto);
      for (final condicion in condiciones) {
        await _bdLocal.insert(_tablaCondicionesProspecto, {
          'codigo': condicion.codigo,
          'descripcion': condicion.descripcion,
        });
      }
    } on DatabaseException catch (e) {
      throw GeneralLocalException(
          'Error al guardar condiciones prospecto: $e');
    }
  }

  /// Obtiene las condiciones del prospecto almacenadas.
  Future<List<CondicionProspecto>> obtenerCondicionesProspecto() async {
    try {
      final rows = await _bdLocal.query(_tablaCondicionesProspecto);
      return rows
          .map((row) => CondicionProspecto(
                codigo: row['codigo'] as String,
                descripcion: row['descripcion'] as String,
              ))
          .toList();
    } on DatabaseException catch (e) {
      throw GeneralLocalException(
          'Error al obtener condiciones prospecto: $e');
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
