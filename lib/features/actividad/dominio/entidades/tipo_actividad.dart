/// Representa un tipo de actividad devuelto por el API.
class TipoActividad {
  /// Identificador único del tipo.
  final int id;

  /// Nombre legible del tipo.
  final String nombre;

  /// Crea una instancia de [TipoActividad].
  const TipoActividad({required this.id, required this.nombre});

  /// Construye un [TipoActividad] a partir de un mapa JSON.
  factory TipoActividad.fromJson(Map<String, dynamic> json) => TipoActividad(
        id: json['Id'] as int,
        nombre: json['Nombre'] as String,
      );

  /// Convierte el [TipoActividad] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Nombre': nombre,
      };
}

/// Representa un sub tipo de actividad devuelto por el API.
class SubTipoActividad {
  /// Identificador único del sub tipo.
  final int id;

  /// Nombre legible del sub tipo.
  final String nombre;

  /// Crea una instancia de [SubTipoActividad].
  const SubTipoActividad({
    required this.id,
    required this.nombre,
  });

  /// Construye un [SubTipoActividad] a partir de un mapa JSON.
  factory SubTipoActividad.fromJson(Map<String, dynamic> json) => SubTipoActividad(
        id: json['Id'] as int,
        nombre: json['Nombre'] as String,
      );

  /// Convierte el [SubTipoActividad] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Nombre': nombre,
      };
}

