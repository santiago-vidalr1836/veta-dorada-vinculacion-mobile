/// Describe la actividad minera verificada durante la visita.
class DescripcionActividadVerificada {
  /// Coordenadas y ubicación geográfica y política.
  final String coordenadas;

  /// Zona de la labor minera.
  final String zona;

  /// Descripción de la actividad minera verificada.
  final String actividad;

  /// Equipos y maquinaria observados.
  final String equipos;

  /// Trabajadores presentes en la actividad.
  final String trabajadores;

  /// Condiciones laborales y de seguridad observadas.
  final String condicionesLaborales;

  /// Crea una instancia de [DescripcionActividadVerificada].
  const DescripcionActividadVerificada({
    required this.coordenadas,
    required this.zona,
    required this.actividad,
    required this.equipos,
    required this.trabajadores,
    required this.condicionesLaborales,
  });

  /// Crea una [DescripcionActividadVerificada] a partir de un mapa JSON.
  factory DescripcionActividadVerificada.fromJson(Map<String, dynamic> json) =>
      DescripcionActividadVerificada(
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

