import 'derecho_minero.dart';
import 'catalogo_item.dart';

/// Representa al proveedor responsable de una visita.
class Proveedor {
  /// Identificador único del proveedor.
  final String id;

  /// Nombre o razón social del proveedor.
  final String nombre;

  /// Tipo de proveedor.
  final CatalogoItem tipo;

  /// RUC del proveedor.
  final String ruc;

  /// Nombre completo del proveedor (si aplica).
  final String? nombreCompleto;

  /// DNI del proveedor (si aplica).
  final String? dni;

  /// Razón social del proveedor.
  final String? razonSocial;

  /// Nombre del representante legal.
  final String? representanteNombre;

  /// DNI del representante legal.
  final String? representanteDni;

  /// Estado del proveedor.
  final CatalogoItem estado;

  /// Correo electrónico de contacto.
  final String? correoElectronico;

  /// Teléfono de contacto.
  final String? telefono;

  /// Whatsapp de la contadora.
  final String? whatsappContadora;

  /// Documento firmado asociado al proveedor.
  final String? documentoFirmado;

  /// Derechos mineros asociados al proveedor.
  final List<DerechoMinero>? derechoMinero;

  /// Crea una instancia de [Proveedor].
  const Proveedor({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.ruc,
    this.nombreCompleto,
    this.dni,
    this.razonSocial,
    this.representanteNombre,
    this.representanteDni,
    required this.estado,
    this.correoElectronico,
    this.telefono,
    this.whatsappContadora,
    this.documentoFirmado,
    this.derechoMinero,
  });

  /// Crea un [Proveedor] a partir de un mapa JSON.
  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        tipo: CatalogoItem.fromJson(json['tipo'] as Map<String, dynamic>),
        ruc: json['ruc'] as String,
        nombreCompleto: json['nombreCompleto'] as String?,
        dni: json['dni'] as String?,
        razonSocial: json['razonSocial'] as String?,
        representanteNombre: json['representanteNombre'] as String?,
        representanteDni: json['representanteDni'] as String?,
        estado: CatalogoItem.fromJson(json['estado'] as Map<String, dynamic>),
        correoElectronico: json['correoElectronico'] as String?,
        telefono: json['telefono'] as String?,
        whatsappContadora: json['whatsappContadora'] as String?,
        documentoFirmado: json['documentoFirmado'] as String?,
        derechoMinero: (json['derechoMinero'] as List<dynamic>?)
            ?.map((e) => DerechoMinero.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Convierte el [Proveedor] en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'tipo': tipo.toJson(),
        'ruc': ruc,
        'nombreCompleto': nombreCompleto,
        'dni': dni,
        'razonSocial': razonSocial,
        'representanteNombre': representanteNombre,
        'representanteDni': representanteDni,
        'estado': estado.toJson(),
        'correoElectronico': correoElectronico,
        'telefono': telefono,
        'whatsappContadora': whatsappContadora,
        'documentoFirmado': documentoFirmado,
        'derechoMinero': derechoMinero?.map((e) => e.toJson()).toList(),
      };
}
