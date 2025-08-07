/// Representa al proveedor responsable de una visita.
class Proveedor {
  /// Identificador único del proveedor.
  final String id;

  /// Nombre o razón social del proveedor.
  final String nombre;

  /// Crea una instancia de [Proveedor].
  const Proveedor({required this.id, required this.nombre});

  /// Crea un [Proveedor] a partir de un mapa JSON.
  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
      );

  /// Convierte el [Proveedor] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
      };
}
