/// Describe la actividad minera observada durante la visita.
class Descripcion {
  /// Coordenadas y ubicación geográfica y política.
  final String coordenadas;

  /// Zona de la labor minera.
  final String zona;

  /// Actividad minera verificada.
  final String actividad;

  /// Equipos y maquinaria observados.
  final String equipos;

  /// Trabajadores presentes en la actividad.
  final String trabajadores;

  /// Condiciones laborales y de seguridad observadas.
  final String condicionesLaborales;

  const Descripcion({
    required this.coordenadas,
    required this.zona,
    required this.actividad,
    required this.equipos,
    required this.trabajadores,
    required this.condicionesLaborales,
  });

  /// Crea una [Descripcion] a partir de un mapa JSON.
  factory Descripcion.fromJson(Map<String, dynamic> json) => Descripcion(
        coordenadas: json['coordenadas'] as String,
        zona: json['zona'] as String,
        actividad: json['actividad'] as String,
        equipos: json['equipos'] as String,
        trabajadores: json['trabajadores'] as String,
        condicionesLaborales: json['condicionesLaborales'] as String,
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'coordenadas': coordenadas,
        'zona': zona,
        'actividad': actividad,
        'equipos': equipos,
        'trabajadores': trabajadores,
        'condicionesLaborales': condicionesLaborales,
      };
}

