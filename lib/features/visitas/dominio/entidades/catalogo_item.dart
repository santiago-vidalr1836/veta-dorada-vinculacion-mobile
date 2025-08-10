/// Elemento genérico de catálogo.
class CatalogoItem {
  /// Código identificador del ítem.
  final String codigo;

  /// Descripción del ítem.
  final String descripcion;

  /// Crea una instancia de [CatalogoItem].
  const CatalogoItem({required this.codigo, required this.descripcion});

  /// Crea un [CatalogoItem] a partir de un mapa JSON.
  factory CatalogoItem.fromJson(Map<String, dynamic> json) => CatalogoItem(
        codigo: json['codigo'] as String,
        descripcion: json['descripcion'] as String,
      );

  /// Convierte el [CatalogoItem] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'descripcion': descripcion,
      };
}
