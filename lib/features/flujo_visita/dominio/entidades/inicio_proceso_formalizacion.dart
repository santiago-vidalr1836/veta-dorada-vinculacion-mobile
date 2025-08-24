/// Define un inicio de proceso de formalización.
class InicioProcesoFormalizacion {
  /// Identificador único del registro.
  final String codigo;

  /// Nombre del inicio de proceso.
  final String nombre;

  /// Crea una instancia de [InicioProcesoFormalizacion].
  const InicioProcesoFormalizacion(
      {required this.codigo, required this.nombre});

  /// Crea un [InicioProcesoFormalizacion] a partir de un mapa JSON.
  factory InicioProcesoFormalizacion.fromJson(Map<String, dynamic> json) =>
      InicioProcesoFormalizacion(
        codigo: json['Codigo'] as String,
        nombre: json['Nombre'] as String,
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Codigo': codigo,
        'Nombre': nombre,
      };
}
