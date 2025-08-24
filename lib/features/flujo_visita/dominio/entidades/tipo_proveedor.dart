/// Representa un tipo de proveedor disponible en el sistema.
class TipoProveedor {
  /// Identificador único del tipo de proveedor.
  final String codigo;

  /// Descripción del tipo de proveedor.
  final String nombre;

  /// Crea una instancia de [TipoProveedor].
  const TipoProveedor({required this.codigo, required this.nombre});

  /// Crea un [TipoProveedor] a partir de un mapa JSON.
  factory TipoProveedor.fromJson(Map<String, dynamic> json) => TipoProveedor(
        codigo: json['Codigo'] as String,
        nombre: json['Nombre'] as String,
      );

  /// Convierte el [TipoProveedor] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Codigo': codigo,
        'Nombre': nombre,
      };
}
