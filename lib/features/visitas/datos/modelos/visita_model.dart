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
        id: json['Id'] as String,
        general: General.fromJson(json['Estado'] as Map<String, dynamic>),
        proveedor:
            Proveedor.fromJson(json['Proveedor'] as Map<String, dynamic>),
        tipoVisita:
            TipoVisita.fromJson(json['TipoVisita'] as Map<String, dynamic>),
        derechoMinero: DerechoMinero.fromJson(
          json['DerechoMinero'] as Map<String, dynamic>,
        ),
      );

  /// Convierte el modelo en un mapa JSON compatible con la API.
  @override
  Map<String, dynamic> toJson() => {
        'Id': id,
        'General': general.toJson(),
        'Proveedor': proveedor.toJson(),
        'TipoVisita': tipoVisita.toJson(),
        'DerechoMinero': derechoMinero.toJson(),
      };
}

