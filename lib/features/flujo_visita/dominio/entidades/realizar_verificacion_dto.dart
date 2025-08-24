import 'actividad.dart';
import 'descripcion.dart';
import 'evaluacion.dart';
import 'estimacion.dart';
import 'foto.dart';
import 'proveedor_snapshot.dart';

/// DTO que agrupa la información necesaria para realizar una verificación.
class RealizarVerificacionDto {
  /// Identificador de la verificación.
  final int idVerificacion;

  /// Identificador de la visita asociada.
  final int idVisita;

  /// Identificador del usuario que realiza la verificación.
  final int idUsuario;

  /// Fecha y hora de inicio registrada en el dispositivo móvil.
  final DateTime fechaInicioMovil;

  /// Fecha y hora de fin registrada en el dispositivo móvil.
  final DateTime fechaFinMovil;

  /// Información del proveedor al momento de la verificación.
  final ProveedorSnapshot proveedorSnapshot;

  /// Lista de actividades observadas.
  final List<Actividad> actividades;

  /// Descripción detallada de la actividad verificada.
  final Descripcion descripcion;

  /// Evaluación realizada durante la visita.
  final Evaluacion evaluacion;

  /// Estimación de producción obtenida.
  final Estimacion estimacion;

  /// Registro fotográfico asociado a la verificación.
  final List<Foto> fotos;

  /// Clave de idempotencia para evitar duplicados en el servidor.
  final String idempotencyKey;

  const RealizarVerificacionDto({
    required this.idVerificacion,
    required this.idVisita,
    required this.idUsuario,
    required this.fechaInicioMovil,
    required this.fechaFinMovil,
    required this.proveedorSnapshot,
    required this.actividades,
    required this.descripcion,
    required this.evaluacion,
    required this.estimacion,
    required this.fotos,
    required this.idempotencyKey,
  });

  /// Crea una instancia a partir de un mapa JSON.
  factory RealizarVerificacionDto.fromJson(Map<String, dynamic> json) =>
      RealizarVerificacionDto(
        idVerificacion: json['idVerificacion'] as int,
        idVisita: json['idVisita'] as int,
        idUsuario: json['idUsuario'] as int,
        fechaInicioMovil: DateTime.parse(json['fechaInicioMovil'] as String),
        fechaFinMovil: DateTime.parse(json['fechaFinMovil'] as String),
        proveedorSnapshot: ProveedorSnapshot.fromJson(
            json['proveedorSnapshot'] as Map<String, dynamic>),
        actividades: (json['actividades'] as List<dynamic>)
            .map((e) => Actividad.fromJson(e as Map<String, dynamic>))
            .toList(),
        descripcion:
            Descripcion.fromJson(json['descripcion'] as Map<String, dynamic>),
        evaluacion:
            Evaluacion.fromJson(json['evaluacion'] as Map<String, dynamic>),
        estimacion:
            Estimacion.fromJson(json['estimacion'] as Map<String, dynamic>),
        fotos: (json['fotos'] as List<dynamic>)
            .map((e) => Foto.fromJson(e as Map<String, dynamic>))
            .toList(),
        idempotencyKey: json['idempotencyKey'] as String,
      );

  /// Convierte la instancia en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'idVerificacion': idVerificacion,
        'idVisita': idVisita,
        'idUsuario': idUsuario,
        'fechaInicioMovil': fechaInicioMovil.toIso8601String(),
        'fechaFinMovil': fechaFinMovil.toIso8601String(),
        'proveedorSnapshot': proveedorSnapshot.toJson(),
        'actividades': actividades.map((e) => e.toJson()).toList(),
        'descripcion': descripcion.toJson(),
        'evaluacion': evaluacion.toJson(),
        'estimacion': estimacion.toJson(),
        'fotos': fotos.map((e) => e.toJson()).toList(),
        'idempotencyKey': idempotencyKey,
      };
}

