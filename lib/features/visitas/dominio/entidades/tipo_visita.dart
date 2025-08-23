/// Describe el tipo de visita a realizar.
class TipoVisita {
  /// Identificador único del tipo de visita.
  final String id;
  final String codigo;
  /// Descripción del tipo de visita.
  final String nombre;

  /// Crea una instancia de [TipoVisita].
  const TipoVisita({required this.id, required this.codigo,required this.nombre});

  /// Crea un [TipoVisita] a partir de un mapa JSON.
  factory TipoVisita.fromJson(Map<String, dynamic> json) => TipoVisita(
        id: json['Id'] as String,
        codigo: json['Codigo'] as String,
        nombre: json['Nombre'] as String
      );

  /// Convierte el [TipoVisita] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Codigo' : codigo,
        'Nombre' : nombre
      };
}
