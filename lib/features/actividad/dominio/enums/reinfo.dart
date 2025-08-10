/// Enumeración que describe el origen de una actividad.
enum Reinfo {
  /// Actividad registrada en REINFO.
  reinfo,

  /// Actividad declarada mediante IGAFOM.
  igafom,

  /// Actividad verificada por la autoridad.
  verificada,

  /// Origen desconocido de la actividad.
  desconocido,
}

/// Extensiones utilitarias para [Reinfo].
extension ReinfoApi on Reinfo {
  /// Representación numérica utilizada por la API.
  int toApi() {
    switch (this) {
      case Reinfo.reinfo:
        return 1;
      case Reinfo.igafom:
        return 2;
      case Reinfo.verificada:
        return 3;
      case Reinfo.desconocido:
        return 0;
    }
  }

  /// Etiqueta legible asociada al origen.
  String get label {
    switch (this) {
      case Reinfo.reinfo:
        return 'Reinfo';
      case Reinfo.igafom:
        return 'IGAFOM';
      case Reinfo.verificada:
        return 'Verificada';
      case Reinfo.desconocido:
        return 'Desconocido';
    }
  }
}

/// Convierte el código proporcionado por la API en un [Reinfo].
Reinfo reinfoFromApi(int? code) {
  switch (code) {
    case 1:
      return Reinfo.reinfo;
    case 2:
      return Reinfo.igafom;
    case 3:
      return Reinfo.verificada;
    default:
      return Reinfo.desconocido;
  }
}

