import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';

import 'derecho_minero.dart';
import 'general.dart';
import 'proveedor.dart';
import 'tipo_visita.dart';

/// Representa una visita programada a un derecho minero.
class Visita {
  /// Identificador único de la visita.
  final int id;

  /// Información general Ede la visita.
  final General estado;

  /// Proveedor encargado de realizar la visita.
  final Proveedor proveedor;

  /// Tipo de visita que se realizará.
  final TipoVisita tipoVisita;

  /// Derecho minero asociado a la visita.
  final DerechoMinero derechoMinero;
  final DateTime fechaProgramada;

  final Usuario geologo;
  final Usuario acopiador;

  /// Crea una instancia de [Visita].
  const Visita({
    required this.id,
    required this.estado,
    required this.proveedor,
    required this.tipoVisita,
    required this.derechoMinero,
    required this.fechaProgramada,
    required this.geologo,
    required this.acopiador
  });

  /// Crea una [Visita] a partir de un mapa JSON.
  factory Visita.fromJson(Map<String, dynamic> json) => Visita(
        id: json['Id'] as int,
        estado: General.fromJson(json['Estado'] as Map<String, dynamic>),
        proveedor:
            Proveedor.fromJson(json['Proveedor'] as Map<String, dynamic>),
        tipoVisita:
            TipoVisita.fromJson(json['TipoVisita'] as Map<String, dynamic>),
        derechoMinero: DerechoMinero.fromJson(
            json['DerechoMinero'] as Map<String, dynamic>),
        fechaProgramada: DateTime.parse(json['FechaProgramada'] as String),
        geologo: Usuario.fromJson(json['Geologo'] as Map<String, dynamic>),
        acopiador: Usuario.fromJson(json['Acopiador'] as Map<String, dynamic>)
      );

  /// Convierte la visita en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'General': estado.toJson(),
        'Proveedor': proveedor.toJson(),
        'TipoVisita': tipoVisita.toJson(),
        'DerechoMinero': derechoMinero.toJson(),
        'FechaProgramada' : fechaProgramada.toIso8601String(),
        'Geologo' : geologo.toJson(),
        'Acopiador' : acopiador.toJson()
      };
}
