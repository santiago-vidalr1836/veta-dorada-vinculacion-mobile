/// Información general de una visita.
class General {
  /// Estado para una visita programada.
  static const String ESTADO_VISITA_PROGRAMADA = 'ESTADO_VISITA_PROGRAMADA';
  /// Estado para una visita en proceso.
  static const String ESTADO_VISITA_EN_PROCESO = 'ESTADO_VISITA_EN_PROCESO';
  /// Estado para una visita realizada.
  static const String ESTADO_VISITA_REALIZADA = 'ESTADO_VISITA_REALIZADA';

  final String codigo;
  final String nombre;
  final String? descripcion;

  /// Crea una instancia de [General].
  const General({
    required this.codigo,
    required this.nombre,
    this.descripcion,
  });

  /// Crea [General] a partir de un mapa JSON.
  factory General.fromJson(Map<String, dynamic> json) => General(
        codigo: json['Codigo'] as String,
        nombre: json['Nombre'] as String,
        descripcion : json['Descripcion'] as String?
  );

  /// Convierte la información general en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Codigo': codigo,
        'Nombre': nombre,
        'Descripcion': descripcion
  };
}
