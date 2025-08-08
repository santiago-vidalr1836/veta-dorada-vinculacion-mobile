import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/derecho_minero.dart';

import 'general.dart';

/// Representa al proveedor responsable de una visita.
class Proveedor {
  /// Identificador único del proveedor.
  final String id;

  /// Nombre o razón social del proveedor.
  final String nombre;
  final General tipo;
  final String ruc;
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
  const Proveedor({required this.id, required this.nombre,required this.tipo,required this.ruc, this.nombreCompleto, this.dni, this.razonSocial, this.representanteNombre, this.representanteDni,required this.estado, this.correoElectronico, this.telefono, this.whatsappContadora, this.documentoFirmado, this.derechoMinero});

  /// Crea un [Proveedor] a partir de un mapa JSON.
  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        id: json['Id'] as String,
        tipo: json['Nombre'] as String,

      );

  /// Convierte el [Proveedor] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
      };
}
