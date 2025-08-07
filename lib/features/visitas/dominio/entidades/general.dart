/// Información general de una visita.
class General {
  /// Estado para una visita programada.
  static const String ESTADO_VISITA_PROGRAMADA = 'PROGRAMADA';

  /// Estado para una visita en proceso.
  static const String ESTADO_VISITA_EN_PROCESO = 'EN_PROCESO';

  /// Estado para una visita finalizada.
  static const String ESTADO_VISITA_FINALIZADA = 'FINALIZADA';

  /// Estado actual de la visita.
  final String estado;

  /// Fecha programada de la visita.
  final DateTime fechaProgramada;

  /// Fecha real de ejecución de la visita.
  final DateTime? fechaEjecucion;

  /// Observaciones adicionales de la visita.
  final String? observaciones;

  /// Crea una instancia de [General].
  const General({
    required this.estado,
    required this.fechaProgramada,
    this.fechaEjecucion,
    this.observaciones,
  });

  /// Crea [General] a partir de un mapa JSON.
  factory General.fromJson(Map<String, dynamic> json) => General(
        estado: json['estado'] as String,
        fechaProgramada: DateTime.parse(json['fechaProgramada'] as String),
        fechaEjecucion: json['fechaEjecucion'] != null
            ? DateTime.parse(json['fechaEjecucion'] as String)
            : null,
        observaciones: json['observaciones'] as String?,
      );

  /// Convierte la información general en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'estado': estado,
        'fechaProgramada': fechaProgramada.toIso8601String(),
        'fechaEjecucion': fechaEjecucion?.toIso8601String(),
        'observaciones': observaciones,
      };
}
