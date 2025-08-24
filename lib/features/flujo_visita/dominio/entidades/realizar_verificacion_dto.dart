
import '../../../actividad/dominio/entidades/actividad.dart';
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
  final DateTime? fechaInicioMovil;

  /// Fecha y hora de fin registrada en el dispositivo móvil.
  final DateTime? fechaFinMovil;

  /// Información del proveedor al momento de la verificación.
  final ProveedorSnapshot? proveedorSnapshot;

  /// Lista de actividades observadas.
  final List<Actividad>? actividades;

  /// Descripción detallada de la actividad verificada.
  final Descripcion? descripcion;

  /// Evaluación realizada durante la visita.
  final Evaluacion? evaluacion;

  /// Estimación de producción obtenida.
  final Estimacion? estimacion;

  /// Registro fotográfico asociado a la verificación.
  final List<Foto>? fotos;

  /// Clave de idempotencia para evitar duplicados en el servidor.
  final String idempotencyKey;

  const RealizarVerificacionDto({
    required this.idVerificacion,
    required this.idVisita,
    required this.idUsuario,
    this.fechaInicioMovil,
    this.fechaFinMovil,
    this.proveedorSnapshot,
    this.actividades,
    this.descripcion,
    this.evaluacion,
    this.estimacion,
    this.fotos,
    required this.idempotencyKey,
  });

  /// Retorna una copia del objeto con los campos actualizados.
  RealizarVerificacionDto copyWith({
    int? idVerificacion,
    int? idVisita,
    int? idUsuario,
    DateTime? fechaInicioMovil,
    DateTime? fechaFinMovil,
    ProveedorSnapshot? proveedorSnapshot,
    List<Actividad>? actividades,
    Descripcion? descripcion,
    Evaluacion? evaluacion,
    Estimacion? estimacion,
    List<Foto>? fotos,
    String? idempotencyKey,
  }) {
    return RealizarVerificacionDto(
      idVerificacion: idVerificacion ?? this.idVerificacion,
      idVisita: idVisita ?? this.idVisita,
      idUsuario: idUsuario ?? this.idUsuario,
      fechaInicioMovil: fechaInicioMovil ?? this.fechaInicioMovil,
      fechaFinMovil: fechaFinMovil ?? this.fechaFinMovil,
      proveedorSnapshot: proveedorSnapshot ?? this.proveedorSnapshot,
      actividades: actividades ?? this.actividades,
      descripcion: descripcion ?? this.descripcion,
      evaluacion: evaluacion ?? this.evaluacion,
      estimacion: estimacion ?? this.estimacion,
      fotos: fotos ?? this.fotos,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    );
  }

  /// Crea una instancia a partir de un mapa JSON.
  factory RealizarVerificacionDto.fromJson(Map<String, dynamic> json) =>
      RealizarVerificacionDto(
        idVerificacion: json['idVerificacion'] as int,
        idVisita: json['idVisita'] as int,
        idUsuario: json['idUsuario'] as int,
        fechaInicioMovil: json['fechaInicioMovil'] != null
            ? DateTime.parse(json['fechaInicioMovil'] as String)
            : null,
        fechaFinMovil: json['fechaFinMovil'] != null
            ? DateTime.parse(json['fechaFinMovil'] as String)
            : null,
        proveedorSnapshot: json['proveedorSnapshot'] != null
            ? ProveedorSnapshot.fromJson(
                json['proveedorSnapshot'] as Map<String, dynamic>)
            : null,
        actividades: (json['actividades'] as List<dynamic>?)
            ?.map((e) => Actividad.fromJson(e as Map<String, dynamic>))
            .toList(),
        descripcion: json['descripcion'] != null
            ? Descripcion.fromJson(json['descripcion'] as Map<String, dynamic>)
            : null,
        evaluacion: json['evaluacion'] != null
            ? Evaluacion.fromJson(json['evaluacion'] as Map<String, dynamic>)
            : null,
        estimacion: json['estimacion'] != null
            ? Estimacion.fromJson(json['estimacion'] as Map<String, dynamic>)
            : null,
        fotos: (json['fotos'] as List<dynamic>?)
            ?.map((e) => Foto.fromJson(e as Map<String, dynamic>))
            .toList(),
        idempotencyKey: json['idempotencyKey'] as String,
      );

  /// Convierte la instancia en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'idVerificacion': idVerificacion,
        'idVisita': idVisita,
        'idUsuario': idUsuario,
        'fechaInicioMovil': fechaInicioMovil?.toIso8601String(),
        'fechaFinMovil': fechaFinMovil?.toIso8601String(),
        'proveedorSnapshot': proveedorSnapshot?.toJson(),
        'actividades': actividades?.map((e) => e.toJson()).toList(),
        'descripcion': descripcion?.toJson(),
        'evaluacion': evaluacion?.toJson(),
        'estimacion': estimacion?.toJson(),
        'fotos': fotos?.map((e) => e.toJson()).toList(),
        'idempotencyKey': idempotencyKey,
      };
}

