import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Servicio encargado de gestionar la base de datos local mediante
/// [sqflite].
///
/// Abre la base de datos y expone operaciones básicas de inserción,
/// actualización y consulta. Implementado como un *singleton* para
/// reutilizar la misma instancia de [Database] durante toda la vida de la
/// aplicación.
class ServicioBdLocal {
  ServicioBdLocal._internal();

  static final ServicioBdLocal _instancia = ServicioBdLocal._internal();

  /// Obtiene la instancia única del servicio.
  factory ServicioBdLocal() => _instancia;

  static const String nombreTablaVisitas = 'visitas';
  static const String nombreTablaTipoProveedor = 'tipo_proveedor';
  static const String nombreTablaInicioProcesoFormalizacion =
      'inicio_proceso_formalizacion';
  static const String nombreTablaTipoActividad = 'tipo_actividad';
  static const String nombreTablaCondicionProspecto =
      'condicion_prospecto';
  static const String nombreTablaRealizarVerificacion =
      'realizar_verificacion';

  static const _nombreBd = 'vinculacion.db';
  static const _versionBd = 4;

  Database? _db;

  /// Obtiene la base de datos abierta o la crea si aún no existe.
  Future<Database> get database async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), _nombreBd);
    _db = await openDatabase(
      path,
      version: _versionBd,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $nombreTablaVisitas(
            id TEXT PRIMARY KEY,
            estado TEXT,
            data TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE $nombreTablaTipoProveedor(
            id TEXT PRIMARY KEY,
            descripcion TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE $nombreTablaInicioProcesoFormalizacion(
            codigo TEXT PRIMARY KEY,
            descripcion TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE $nombreTablaTipoActividad(
            id INTEGER PRIMARY KEY,
            nombre TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE $nombreTablaCondicionProspecto(
            codigo TEXT PRIMARY KEY,
            descripcion TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE $nombreTablaRealizarVerificacion(
            idVisita TEXT PRIMARY KEY,
            data TEXT
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $nombreTablaTipoProveedor(
              id TEXT PRIMARY KEY,
              descripcion TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $nombreTablaInicioProcesoFormalizacion(
              id TEXT PRIMARY KEY,
              descripcion TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $nombreTablaTipoActividad(
              id INTEGER PRIMARY KEY,
              nombre TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $nombreTablaCondicionProspecto(
              id TEXT PRIMARY KEY,
              descripcion TEXT
            );
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $nombreTablaRealizarVerificacion(
              idVisita TEXT PRIMARY KEY,
              data TEXT
            );
          ''');
        }
        if (oldVersion < 4) {
          try {
            await db.execute(
                'ALTER TABLE $nombreTablaTipoActividad RENAME COLUMN descripcion TO nombre;');
          } catch (_) {}
          try {
            await db.execute(
                'ALTER TABLE $nombreTablaTipoActividad RENAME COLUMN codigo TO id;');
          } catch (_) {}
        }
      },
    );
    return _db!;
  }

  /// Inserta [values] en [table].
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
  }) async {
    final db = await database;
    return db.insert(
      table,
      values,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Actualiza registros en [table].
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Elimina registros de [table].
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Realiza una consulta a [table].
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    List<String>? columns,
  }) async {
    final db = await database;
    return db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Ejecuta una consulta SQL sin procesar.
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await database;
    return db.rawQuery(sql, arguments);
  }

  /// Cierra la base de datos abierta.
  ///
  /// Este método se utiliza principalmente para liberar recursos durante
  /// procesos de prueba. En la aplicación normal no suele ser necesario
  /// cerrarla manualmente.
  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}
