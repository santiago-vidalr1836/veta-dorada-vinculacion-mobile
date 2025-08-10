/// Representa un tipo de actividad devuelto por el API.
class TipoActividad {
  /// Identificador único del tipo.
  final int id;

  /// Descripción legible del tipo.
  final String descripcion;

  /// Crea una instancia de [TipoActividad].
  const TipoActividad({required this.id, required this.descripcion});

  /// Construye un [TipoActividad] a partir de un mapa JSON.
  factory TipoActividad.fromJson(Map<String, dynamic> json) => TipoActividad(
        id: json['Id'] as int,
        descripcion: json['Descripcion'] as String,
      );

  /// Convierte el [TipoActividad] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Descripcion': descripcion,
      };
}

/// Representa un sub tipo de actividad devuelto por el API.
class SubTipoActividad {
  /// Identificador único del sub tipo.
  final int id;

  /// Descripción legible del sub tipo.
  final String descripcion;

  /// Identificador del tipo de actividad al que pertenece.
  final int idTipoActividad;

  /// Crea una instancia de [SubTipoActividad].
  const SubTipoActividad({
    required this.id,
    required this.descripcion,
    required this.idTipoActividad,
  });

  /// Construye un [SubTipoActividad] a partir de un mapa JSON.
  factory SubTipoActividad.fromJson(Map<String, dynamic> json) => SubTipoActividad(
        id: json['Id'] as int,
        descripcion: json['Descripcion'] as String,
        idTipoActividad: json['IdTipoActividad'] as int,
      );

  /// Convierte el [SubTipoActividad] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Descripcion': descripcion,
        'IdTipoActividad': idTipoActividad,
      };
}

