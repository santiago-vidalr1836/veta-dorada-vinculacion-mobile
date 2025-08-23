import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/derecho_minero.dart';

import 'general.dart';

/// Representa al proveedor responsable de una visita.
class Proveedor {
  /// Identificador único del proveedor.
  final int id;

  final General tipo;
  final String ruc;
  ///Nombre o razón social del proveedor.
  final String? nombreCompleto;
  final String? dni;
  final String? razonSocial;
  final String? representanteNombre;
  final String? representanteDni;
  final General estado;
  final String? correoElectronico;
  final String? telefono;
  final String? whatsappContadora;
  final String? documentoFirmado;
  final List<DerechoMinero>? derechoMinero;

  /// Crea una instancia de [Provethis.tipo, this.ruc, this.nombreCompleto, this.dni, this.razonSocial, this.representanteNombre, this.representanteDni, this.estado, this.correoElectronico, this.telefono, this.whatsappContadora, this.documentoFirmado, this.derechoMinero, edor].
  const Proveedor({required this.id,required this.tipo,required this.ruc, this.nombreCompleto, this.dni, this.razonSocial, this.representanteNombre, this.representanteDni,required this.estado, this.correoElectronico, this.telefono, this.whatsappContadora, this.documentoFirmado, this.derechoMinero});

  /// Crea un [Proveedor] a partir de un mapa JSON.
  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        id: json['Id'] as int,
        tipo: General.fromJson(json['Tipo'] as Map<String, dynamic>),
        ruc: json['Ruc'] as String,
        nombreCompleto: json['NombreCompleto'] as String?,
        dni : json['Dni'] as String?,
        razonSocial: json['RazonSocial'] as String?,
        representanteNombre: json['RepresentanteNombre'] as String?,
        representanteDni: json['RepresentanteDni'] as String?,
        estado:  General.fromJson(json['Estado'] as Map<String, dynamic>),
        correoElectronico: json['CorreoElectronico'] as String?,
        telefono: json['Telefono'] as String?,
        whatsappContadora: json['WhatsappContadora'] as String?,
        documentoFirmado: json['DocumentoFirmado'] as String?,
        derechoMinero:(json['DerechoMinero'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()               // evita nulls/elementos no-mapa
            .map((m) => DerechoMinero.fromJson(m))
            .toList()
            ?? const [],
      );

  /// Convierte el [Proveedor] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Ruc': ruc
  };

  nombre() {
    return nombreCompleto??razonSocial;
  }
}
