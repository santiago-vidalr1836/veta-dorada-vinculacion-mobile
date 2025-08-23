/// Fotografía registrada durante la visita.
class Foto {
  /// Ruta local o URL de la imagen.
  final String imagen;

  /// Título que describe el contenido.
  final String titulo;

  /// Descripción detallada de lo observado.
  final String descripcion;

  /// Fecha de captura de la foto.
  final DateTime fecha;

  /// Latitud donde se capturó la foto.
  final double latitud;

  /// Longitud donde se capturó la foto.
  final double longitud;

  const Foto({
    required this.imagen,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.latitud,
    required this.longitud,
  });

  /// Crea una [Foto] a partir de un mapa JSON.
  factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        imagen: json['imagen'] as String,
        titulo: json['titulo'] as String,
        descripcion: json['descripcion'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
        latitud: (json['latitud'] as num).toDouble(),
        longitud: (json['longitud'] as num).toDouble(),
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'imagen': imagen,
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha.toIso8601String(),
        'latitud': latitud,
        'longitud': longitud,
      };
}

