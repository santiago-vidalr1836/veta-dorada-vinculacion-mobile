/// Estimación de producción calculada durante la visita.
class Estimacion {
  /// Capacidad diaria de producción.
  final double capacidadDiaria;

  /// Días de operación considerados.
  final double diasOperacion;

  /// Resultado de la estimación.
  final double produccionEstimada;

  const Estimacion({
    required this.capacidadDiaria,
    required this.diasOperacion,
    required this.produccionEstimada,
  });

  /// Crea una [Estimacion] a partir de un mapa JSON.
  factory Estimacion.fromJson(Map<String, dynamic> json) => Estimacion(
        capacidadDiaria: (json['capacidadDiaria'] as num).toDouble(),
        diasOperacion: (json['diasOperacion'] as num).toDouble(),
        produccionEstimada: (json['produccionEstimada'] as num).toDouble(),
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'capacidadDiaria': capacidadDiaria,
        'diasOperacion': diasOperacion,
        'produccionEstimada': produccionEstimada,
      };
}

