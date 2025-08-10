/// Representa un tipo de proveedor disponible en el sistema.
class TipoProveedor {
  /// Identificador único del tipo de proveedor.
  final String id;

  /// Descripción del tipo de proveedor.
  final String descripcion;

  /// Crea una instancia de [TipoProveedor].
  const TipoProveedor({required this.id, required this.descripcion});

  /// Crea un [TipoProveedor] a partir de un mapa JSON.
  factory TipoProveedor.fromJson(Map<String, dynamic> json) => TipoProveedor(
        id: json['id'] as String,
        descripcion: json['descripcion'] as String,
      );

  /// Convierte el [TipoProveedor] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'descripcion': descripcion,
      };
}
