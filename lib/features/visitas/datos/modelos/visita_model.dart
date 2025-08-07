import '../../dominio/entidades/derecho_minero.dart';
import '../../dominio/entidades/general.dart';
import '../../dominio/entidades/proveedor.dart';
import '../../dominio/entidades/tipo_visita.dart';
import '../../dominio/entidades/visita.dart';

/// Modelo que representa una visita obtenida desde fuentes de datos.
///
/// Este modelo extiende la entidad de dominio [Visita] y proporciona
/// métodos para convertir entre JSON y las clases de dominio.
class VisitaModel extends Visita {
  /// Crea una instancia de [VisitaModel].
  const VisitaModel({
    required super.id,
    required super.general,
    required super.proveedor,
    required super.tipoVisita,
    required super.derechoMinero,
  });

  /// Crea un [VisitaModel] a partir de un mapa JSON.
  factory VisitaModel.fromJson(Map<String, dynamic> json) => VisitaModel(
        id: json['id'] as String,
        general: General.fromJson(json['general'] as Map<String, dynamic>),
        proveedor:
            Proveedor.fromJson(json['proveedor'] as Map<String, dynamic>),
        tipoVisita:
            TipoVisita.fromJson(json['tipoVisita'] as Map<String, dynamic>),
        derechoMinero: DerechoMinero.fromJson(
          json['derechoMinero'] as Map<String, dynamic>,
        ),
      );

  /// Convierte el modelo en un mapa JSON compatible con la API.
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'general': general.toJson(),
        'proveedor': proveedor.toJson(),
        'tipoVisita': tipoVisita.toJson(),
        'derechoMinero': derechoMinero.toJson(),
      };
}

