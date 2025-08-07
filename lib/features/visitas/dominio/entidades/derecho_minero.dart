/// Derecho minero asociado a la visita.
class DerechoMinero {
  /// Identificador único del derecho minero.
  final String id;

  /// Código oficial del derecho minero.
  final String codigo;

  /// Nombre del derecho minero.
  final String nombre;

  /// Crea una instancia de [DerechoMinero].
  const DerechoMinero({
    required this.id,
    required this.codigo,
    required this.nombre,
  });

  /// Crea un [DerechoMinero] a partir de un mapa JSON.
  factory DerechoMinero.fromJson(Map<String, dynamic> json) => DerechoMinero(
        id: json['id'] as String,
        codigo: json['codigo'] as String,
        nombre: json['nombre'] as String,
      );

  /// Convierte el [DerechoMinero] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'nombre': nombre,
      };
}
