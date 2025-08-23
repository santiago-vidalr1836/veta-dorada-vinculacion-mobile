/// Información de la actividad minera registrada durante la visita.
class Actividad {
  /// Identificador del tipo de actividad.
  final int idTipoActividad;

  /// Identificador del sub tipo de actividad.
  final int idSubTipoActividad;

  /// Sistema UTM utilizado.
  final int? sistemaUtm;

  /// Zona UTM.
  final int? zonaUtm;

  /// Coordenada Este.
  final double utmEste;

  /// Coordenada Norte.
  final double utmNorte;

  /// Derecho minero asociado si aplica.
  final String? derechoMinero;

  const Actividad({
    required this.idTipoActividad,
    required this.idSubTipoActividad,
    this.sistemaUtm,
    this.zonaUtm,
    required this.utmEste,
    required this.utmNorte,
    this.derechoMinero,
  });

  /// Crea una [Actividad] a partir de un mapa JSON.
  factory Actividad.fromJson(Map<String, dynamic> json) => Actividad(
        idTipoActividad: json['idTipoActividad'] as int,
        idSubTipoActividad: json['idSubTipoActividad'] as int,
        sistemaUtm: json['sistemaUtm'] as int?,
        zonaUtm: json['zonaUtm'] as int?,
        utmEste: (json['utmEste'] as num).toDouble(),
        utmNorte: (json['utmNorte'] as num).toDouble(),
        derechoMinero: json['derechoMinero'] as String?,
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'idTipoActividad': idTipoActividad,
        'idSubTipoActividad': idSubTipoActividad,
        'sistemaUtm': sistemaUtm,
        'zonaUtm': zonaUtm,
        'utmEste': utmEste,
        'utmNorte': utmNorte,
        'derechoMinero': derechoMinero,
      };
}

