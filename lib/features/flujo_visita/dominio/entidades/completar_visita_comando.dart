import 'actividad.dart';
import 'descripcion.dart';
import 'estimacion.dart';
import 'evaluacion.dart';
import 'foto.dart';
import 'proveedor_snapshot.dart';

/// Comando para completar la verificación de una visita.
class CompletarVisitaComando {
  /// Identificador de la visita que se actualiza.
  final int idVisita;

  /// Información del proveedor al momento de la visita.
  final ProveedorSnapshot proveedor;

  /// Actividad minera registrada.
  final Actividad actividad;

  /// Descripción detallada de la actividad.
  final Descripcion descripcion;

  /// Evaluación realizada durante la visita.
  final Evaluacion evaluacion;

  /// Estimación de producción calculada.
  final Estimacion estimacion;

  /// Registro fotográfico asociado.
  final List<Foto> fotos;

  const CompletarVisitaComando({
    required this.idVisita,
    required this.proveedor,
    required this.actividad,
    required this.descripcion,
    required this.evaluacion,
    required this.estimacion,
    required this.fotos,
  });

  /// Crea un [CompletarVisitaComando] a partir de un mapa JSON.
  factory CompletarVisitaComando.fromJson(Map<String, dynamic> json) =>
      CompletarVisitaComando(
        idVisita: json['idVisita'] as int,
        proveedor:
            ProveedorSnapshot.fromJson(json['proveedor'] as Map<String, dynamic>),
        actividad: Actividad.fromJson(json['actividad'] as Map<String, dynamic>),
        descripcion:
            Descripcion.fromJson(json['descripcion'] as Map<String, dynamic>),
        evaluacion:
            Evaluacion.fromJson(json['evaluacion'] as Map<String, dynamic>),
        estimacion:
            Estimacion.fromJson(json['estimacion'] as Map<String, dynamic>),
        fotos: (json['fotos'] as List<dynamic>)
            .map((e) => Foto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Convierte el comando en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'idVisita': idVisita,
        'proveedor': proveedor.toJson(),
        'actividad': actividad.toJson(),
        'descripcion': descripcion.toJson(),
        'evaluacion': evaluacion.toJson(),
        'estimacion': estimacion.toJson(),
        'fotos': fotos.map((e) => e.toJson()).toList(),
      };
}

