import '../enums/origen.dart';

/// Describe los datos principales de una actividad minera.
class Actividad {
  /// Identificador único de la actividad.
  final String id;

  /// Origen de la actividad según su registro.
  final Origen origen;

  /// Identificador del tipo de actividad.
  final int idTipoActividad;

  /// Identificador del sub tipo de actividad.
  final int idSubTipoActividad;

  /// Sistema de coordenadas UTM utilizado.
  final int? sistemaUTM;

  /// Coordenada Este en el sistema UTM.
  final double utmEste;

  /// Coordenada Norte en el sistema UTM.
  final double utmNorte;

  /// Zona UTM en la que se ubica la actividad.
  final int? zonaUTM;

  /// Descripción adicional de la actividad.
  final String? descripcion;

  /// Derecho minero asociado si aplica.
  final String? derechoMinero;

  /// Crea una instancia de [Actividad].
  const Actividad({
    required this.id,
    required this.origen,
    required this.idTipoActividad,
    required this.idSubTipoActividad,
    this.sistemaUTM,
    required this.utmEste,
    required this.utmNorte,
    this.zonaUTM,
    this.descripcion,
    this.derechoMinero,
  });

  /// Crea una [Actividad] a partir de un mapa JSON.
  factory Actividad.fromJson(Map<String, dynamic> json) => Actividad(
        id: json['Id'] as String,
        origen: origenFromApi(json['Origen'] as int?),
        idTipoActividad: json['IdTipoActividad'] as int,
        idSubTipoActividad: json['IdSubTipoActividad'] as int,
        sistemaUTM:
            (json['SistemaUTM'] ?? json['sistemaUtm']) as int?,
        utmEste: (json['UtmEste'] as num).toDouble(),
        utmNorte: (json['UtmNorte'] as num).toDouble(),
        zonaUTM: json['ZonaUTM'] as int? ?? json['zonaUtm'] as int?,
        descripcion: json['Descripcion'] as String?,
        derechoMinero:
            json['DerechoMinero'] as String? ?? json['derechoMinero'] as String?,
      );

  /// Convierte la [Actividad] en un mapa JSON compatible con la API.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Origen': origen.toApi(),
        'IdTipoActividad': idTipoActividad,
        'IdSubTipoActividad': idSubTipoActividad,
        'SistemaUTM': sistemaUTM,
        'UtmEste': utmEste,
        'UtmNorte': utmNorte,
        'ZonaUTM': zonaUTM,
        'Descripcion': descripcion,
        'DerechoMinero': derechoMinero,
      };
}

