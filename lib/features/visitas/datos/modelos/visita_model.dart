import '../../dominio/entidades/derecho_minero.dart';
import '../../dominio/entidades/general.dart';
import '../../dominio/entidades/proveedor.dart';
import '../../dominio/entidades/tipo_visita.dart';
import '../../dominio/entidades/visita.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';

/// Modelo que representa una visita obtenida desde fuentes de datos.
///
/// Este modelo extiende la entidad de dominio [Visita] y proporciona
/// métodos para convertir entre JSON y las clases de dominio.
class VisitaModel extends Visita {
  /// Crea una instancia de [VisitaModel].
  const VisitaModel({
    required super.id,
    required super.estado,
    required super.proveedor,
    required super.tipoVisita,
    required super.derechoMinero,
    required super.creador,
    super.geologo,
    super.acopiador,
    super.fechaProgramada,
    required super.fechaCreacion,
    required super.flagMedicionCapacidad,
    required super.codigoDepartamento,
    required super.codigoProvincia,
    required super.codigoDistrito,
  });

  /// Crea un [VisitaModel] a partir de un mapa JSON.
  factory VisitaModel.fromJson(Map<String, dynamic> json) => VisitaModel(
        id: json['Id'] as String,
        estado: General.fromJson(json['Estado'] as Map<String, dynamic>),
        proveedor:
            Proveedor.fromJson(json['Proveedor'] as Map<String, dynamic>),
        tipoVisita:
            TipoVisita.fromJson(json['TipoVisita'] as Map<String, dynamic>),
        derechoMinero: DerechoMinero.fromJson(
          json['DerechoMinero'] as Map<String, dynamic>,
        ),
        creador:
            Usuario.fromJson(json['UsuarioCreador'] as Map<String, dynamic>),
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

  /// Convierte el modelo en un mapa JSON compatible con la API.
  @override
  Map<String, dynamic> toJson() => {
        'Id': id,
        'General': estado.toJson(),
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

