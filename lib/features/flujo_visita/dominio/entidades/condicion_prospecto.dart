/// Representa una condición del prospecto verificada durante la visita.
class CondicionProspecto {
  /// Identificador único de la condición.
  final String codigo;

  /// Descripción de la condición.
  final String nombre;

  /// Crea una instancia de [CondicionProspecto].
  const CondicionProspecto({required this.codigo, required this.nombre});

  /// Crea un [CondicionProspecto] a partir de un mapa JSON.
  factory CondicionProspecto.fromJson(Map<String, dynamic> json) =>
      CondicionProspecto(
        codigo: json['Codigo'] as String,
        nombre: json['Nombre'] as String,
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Codigo': codigo,
        'Nombre': nombre,
      };
}
