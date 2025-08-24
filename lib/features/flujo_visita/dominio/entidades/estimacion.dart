/// Estimación de producción calculada durante la visita.
class Estimacion {
  /// Longitud de avance en metros.
  final double longitudAvance;

  /// Altura del frente en metros.
  final double alturaFrente;

  /// Espesor de la veta en metros.
  final double espesorVeta;

  /// Número de disparos por día.
  final double numeroDisparosDia;

  /// Días trabajados durante el mes.
  final double diasTrabajados;

  /// Porcentaje de roca caja considerado.
  final double porcentajeRocaCaja;

  /// Producción diaria estimada (Pd).
  final double produccionDiariaEstimada;

  /// Producción mensual estimada (pme).
  final double produccionMensualEstimada;

  /// Producción mensual final (incluyendo roca caja).
  final double produccionMensual;

  const Estimacion({
    required this.longitudAvance,
    required this.alturaFrente,
    required this.espesorVeta,
    required this.numeroDisparosDia,
    required this.diasTrabajados,
    required this.porcentajeRocaCaja,
    required this.produccionDiariaEstimada,
    required this.produccionMensualEstimada,
    required this.produccionMensual,
  });

  /// Crea una [Estimacion] a partir de un mapa JSON.
  factory Estimacion.fromJson(Map<String, dynamic> json) => Estimacion(
        longitudAvance: (json['longitudAvance'] as num).toDouble(),
        alturaFrente: (json['alturaFrente'] as num).toDouble(),
        espesorVeta: (json['espesorVeta'] as num).toDouble(),
        numeroDisparosDia: (json['numeroDisparosDia'] as num).toDouble(),
        diasTrabajados: (json['diasTrabajados'] as num).toDouble(),
        porcentajeRocaCaja: (json['porcentajeRocaCaja'] as num).toDouble(),
        produccionDiariaEstimada:
            (json['produccionDiariaEstimada'] as num).toDouble(),
        produccionMensualEstimada:
            (json['produccionMensualEstimada'] as num).toDouble(),
        produccionMensual: (json['produccionMensual'] as num).toDouble(),
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'longitudAvance': longitudAvance,
        'alturaFrente': alturaFrente,
        'espesorVeta': espesorVeta,
        'numeroDisparosDia': numeroDisparosDia,
        'diasTrabajados': diasTrabajados,
        'porcentajeRocaCaja': porcentajeRocaCaja,
        'produccionDiariaEstimada': produccionDiariaEstimada,
        'produccionMensualEstimada': produccionMensualEstimada,
        'produccionMensual': produccionMensual,
      };
}

