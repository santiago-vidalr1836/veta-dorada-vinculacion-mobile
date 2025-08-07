/// Describe el tipo de visita a realizar.
class TipoVisita {
  /// Identificador único del tipo de visita.
  final String id;

  /// Descripción del tipo de visita.
  final String descripcion;

  /// Crea una instancia de [TipoVisita].
  const TipoVisita({required this.id, required this.descripcion});

  /// Crea un [TipoVisita] a partir de un mapa JSON.
  factory TipoVisita.fromJson(Map<String, dynamic> json) => TipoVisita(
        id: json['id'] as String,
        descripcion: json['descripcion'] as String,
      );

  /// Convierte el [TipoVisita] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'descripcion': descripcion,
      };
}
