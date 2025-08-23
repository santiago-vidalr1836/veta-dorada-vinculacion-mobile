/// Derecho minero asociado a la visita.
class DerechoMinero {
  /// Identificador único del derecho minero.
  final int id;

  /// Código oficial del derecho minero.
  final String codigo;

  /// Nombre del derecho minero.
  final String denominacion;

  /// Crea una instancia de [DerechoMinero].
  const DerechoMinero({
    required this.id,
    required this.codigo,
    required this.denominacion,
  });

  /// Crea un [DerechoMinero] a partir de un mapa JSON.
  factory DerechoMinero.fromJson(Map<String, dynamic> json) => DerechoMinero(
        id: json['Id'] as int,
        codigo: json['CodigoUnico'] as String,
        denominacion: json['Denominacion'] as String,
      );

  /// Convierte el [DerechoMinero] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'CodigoUnico': codigo,
        'Denominacion': denominacion,
      };
}
