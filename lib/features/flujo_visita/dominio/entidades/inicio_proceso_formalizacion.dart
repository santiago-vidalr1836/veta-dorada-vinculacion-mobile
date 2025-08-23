/// Define un inicio de proceso de formalización.
class InicioProcesoFormalizacion {
  /// Identificador único del registro.
  final String id;

  /// Descripción del inicio de proceso.
  final String descripcion;

  /// Crea una instancia de [InicioProcesoFormalizacion].
  const InicioProcesoFormalizacion(
      {required this.id, required this.descripcion});

  /// Crea un [InicioProcesoFormalizacion] a partir de un mapa JSON.
  factory InicioProcesoFormalizacion.fromJson(Map<String, dynamic> json) =>
      InicioProcesoFormalizacion(
        id: json['id'] as String,
        descripcion: json['descripcion'] as String,
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'descripcion': descripcion,
      };
}
