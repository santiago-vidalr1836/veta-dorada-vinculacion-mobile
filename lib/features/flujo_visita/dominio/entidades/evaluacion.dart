/// Evaluación de la labor realizada durante la visita.
class Evaluacion {
  /// Identificador de la condición del prospecto.
  final String idCondicionProspecto;

  /// Anotaciones adicionales de la evaluación.
  final String? anotacion;

  const Evaluacion({
    required this.idCondicionProspecto,
    this.anotacion,
  });

  /// Crea una [Evaluacion] a partir de un mapa JSON.
  factory Evaluacion.fromJson(Map<String, dynamic> json) => Evaluacion(
        idCondicionProspecto: json['idCondicionProspecto'] as String,
        anotacion: json['anotacion'] as String?,
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'idCondicionProspecto': idCondicionProspecto,
        'anotacion': anotacion,
      };
}

