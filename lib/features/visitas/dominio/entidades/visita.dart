import 'derecho_minero.dart';
import 'general.dart';
import 'proveedor.dart';
import 'tipo_visita.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';

/// Representa una visita programada a un derecho minero.
class Visita {
  /// Identificador único de la visita.
  final String id;

  /// Información general de la visita.
  final General estado;

  /// Proveedor encargado de realizar la visita.
  final Proveedor proveedor;

  /// Tipo de visita que se realizará.
  final TipoVisita tipoVisita;

  /// Derecho minero asociado a la visita.
  final DerechoMinero derechoMinero;

  /// Usuario que creó la visita.
  final Usuario creador;

  /// Usuario geólogo asignado a la visita.
  final Usuario? geologo;

  /// Usuario acopiador asignado a la visita.
  final Usuario? acopiador;

  /// Fecha programada para la visita.
  final DateTime? fechaProgramada;

  /// Fecha de creación de la visita.
  final DateTime fechaCreacion;

  /// Indica si se realizó la medición de capacidad.
  final bool flagMedicionCapacidad;

  /// Código del departamento donde se realizará la visita.
  final String codigoDepartamento;

  /// Código de la provincia donde se realizará la visita.
  final String codigoProvincia;

  /// Código del distrito donde se realizará la visita.
  final String codigoDistrito;

  /// Crea una instancia de [Visita].
  const Visita({
    required this.id,
    required this.estado,
    required this.proveedor,
    required this.tipoVisita,
    required this.derechoMinero,
    required this.creador,
    this.geologo,
    this.acopiador,
    this.fechaProgramada,
    required this.fechaCreacion,
    required this.flagMedicionCapacidad,
    required this.codigoDepartamento,
    required this.codigoProvincia,
    required this.codigoDistrito,
  });

  /// Crea una [Visita] a partir de un mapa JSON.
  factory Visita.fromJson(Map<String, dynamic> json) => Visita(
        id: json['Id'] as String,
        estado: General.fromJson(json['Estado'] as Map<String, dynamic>),
        proveedor:
            Proveedor.fromJson(json['Proveedor'] as Map<String, dynamic>),
        tipoVisita:
            TipoVisita.fromJson(json['TipoVisita'] as Map<String, dynamic>),
        derechoMinero: DerechoMinero.fromJson(
            json['DerechoMinero'] as Map<String, dynamic>),
        creador: Usuario.fromJson(
            json['UsuarioCreador'] as Map<String, dynamic>),
        geologo: json['Geologo'] != null
            ? Usuario.fromJson(json['Geologo'] as Map<String, dynamic>)
            : null,
        acopiador: json['Acopiador'] != null
            ? Usuario.fromJson(json['Acopiador'] as Map<String, dynamic>)
            : null,
        fechaProgramada: json['FechaProgramada'] != null
            ? DateTime.parse(json['FechaProgramada'] as String)
            : null,
        fechaCreacion: DateTime.parse(json['FechaCreacion'] as String),
        flagMedicionCapacidad: json['FlagMedicionCapacidad'] as bool,
        codigoDepartamento: json['CodigoDepartamento'] as String,
        codigoProvincia: json['CodigoProvincia'] as String,
        codigoDistrito: json['CodigoDistrito'] as String,
      );

  /// Convierte la visita en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Estado': estado.toJson(),
        'Proveedor': proveedor.toJson(),
        'TipoVisita': tipoVisita.toJson(),
        'DerechoMinero': derechoMinero.toJson(),
        'UsuarioCreador': creador.toJson(),
        'Geologo': geologo?.toJson(),
        'Acopiador': acopiador?.toJson(),
        'FechaProgramada': fechaProgramada?.toIso8601String(),
        'FechaCreacion': fechaCreacion.toIso8601String(),
        'FlagMedicionCapacidad': flagMedicionCapacidad,
        'CodigoDepartamento': codigoDepartamento,
        'CodigoProvincia': codigoProvincia,
        'CodigoDistrito': codigoDistrito,
      };
}
