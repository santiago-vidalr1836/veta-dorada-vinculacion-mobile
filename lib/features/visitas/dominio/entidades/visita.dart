import 'derecho_minero.dart';
import 'general.dart';
import 'proveedor.dart';
import 'tipo_visita.dart';

/// Representa una visita programada a un derecho minero.
class Visita {
  /// Identificador único de la visita.
  final String id;

  /// Información general de la visita.
  final General general;

  /// Proveedor encargado de realizar la visita.
  final Proveedor proveedor;

  /// Tipo de visita que se realizará.
  final TipoVisita tipoVisita;

  /// Derecho minero asociado a la visita.
  final DerechoMinero derechoMinero;

  /// Crea una instancia de [Visita].
  const Visita({
    required this.id,
    required this.general,
    required this.proveedor,
    required this.tipoVisita,
    required this.derechoMinero,
  });

  /// Crea una [Visita] a partir de un mapa JSON.
  factory Visita.fromJson(Map<String, dynamic> json) => Visita(
        id: json['id'] as String,
        general: General.fromJson(json['general'] as Map<String, dynamic>),
        proveedor:
            Proveedor.fromJson(json['proveedor'] as Map<String, dynamic>),
        tipoVisita:
            TipoVisita.fromJson(json['tipoVisita'] as Map<String, dynamic>),
        derechoMinero: DerechoMinero.fromJson(
            json['derechoMinero'] as Map<String, dynamic>),
      );

  /// Convierte la visita en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'general': general.toJson(),
        'proveedor': proveedor.toJson(),
        'tipoVisita': tipoVisita.toJson(),
        'derechoMinero': derechoMinero.toJson(),
      };
}
