/// Representa un resumen de la información del proveedor.
class ProveedorSnapshot {
  /// Tipo de persona del proveedor (NATURAL o JURIDICA).
  final String tipoPersona;

  /// Nombre del proveedor o representante.
  final String nombre;

  /// Número de RUC en caso de persona jurídica.
  final String? ruc;

  /// Razón social si aplica.
  final String? razonSocial;

  /// Nombre del representante legal si aplica.
  final String? representanteLegal;

  /// Indica si inició el proceso de formalización.
  final bool inicioFormalizacion;

  /// Crea una instancia de [ProveedorSnapshot].
  const ProveedorSnapshot({
    required this.tipoPersona,
    required this.nombre,
    this.ruc,
    this.razonSocial,
    this.representanteLegal,
    required this.inicioFormalizacion,
  });

  /// Crea un [ProveedorSnapshot] a partir de un mapa JSON.
  factory ProveedorSnapshot.fromJson(Map<String, dynamic> json) =>
      ProveedorSnapshot(
        tipoPersona: json['tipoPersona'] as String,
        nombre: json['nombre'] as String,
        ruc: json['ruc'] as String?,
        razonSocial: json['razonSocial'] as String?,
        representanteLegal: json['representanteLegal'] as String?,
        inicioFormalizacion: json['inicioFormalizacion'] as bool? ?? false,
      );

  /// Convierte la entidad en un mapa JSON.
  Map<String, dynamic> toJson() => {
        'tipoPersona': tipoPersona,
        'nombre': nombre,
        'ruc': ruc,
        'razonSocial': razonSocial,
        'representanteLegal': representanteLegal,
        'inicioFormalizacion': inicioFormalizacion,
      };
}

