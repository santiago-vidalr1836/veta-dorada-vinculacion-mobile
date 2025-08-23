/// Representa un registro fotográfico tomado durante la verificación de la visita.
class RegistroFotografico {
  /// Ruta local donde se encuentra almacenada la fotografía.
  final String path;

  /// Título que describe el contenido de la imagen.
  final String titulo;

  /// Descripción detallada de lo observado en la fotografía.
  final String descripcion;

  /// Fecha y hora en que se tomó la fotografía.
  final DateTime fecha;

  /// Latitud de la ubicación donde se capturó la fotografía.
  final double latitud;

  /// Longitud de la ubicación donde se capturó la fotografía.
  final double longitud;

  /// Crea una instancia de [RegistroFotografico].
  const RegistroFotografico({
    required this.path,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.latitud,
    required this.longitud,
  });

  /// Crea un [RegistroFotografico] a partir de un mapa JSON.
  factory RegistroFotografico.fromJson(Map<String, dynamic> json) =>
      RegistroFotografico(
        path: json['path'] as String,
        titulo: json['titulo'] as String,
        descripcion: json['descripcion'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
        latitud: (json['latitud'] as num).toDouble(),
        longitud: (json['longitud'] as num).toDouble(),
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'path': path,
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha.toIso8601String(),
        'latitud': latitud,
        'longitud': longitud,
      };
}

