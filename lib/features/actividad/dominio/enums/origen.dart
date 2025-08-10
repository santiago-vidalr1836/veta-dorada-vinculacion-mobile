/// Enumeración que describe el origen de una actividad.
enum Origen {
  /// Actividad registrada en REINFO.
  reinfo,

  /// Actividad declarada mediante IGAFOM.
  igafom,

  /// Actividad verificada por la autoridad.
  verificada,

  /// Origen desconocido de la actividad.
  desconocido,
}

/// Extensiones utilitarias para [Origen].
extension OrigenApi on Origen {
  /// Representación numérica utilizada por la API.
  int toApi() {
    switch (this) {
      case Origen.reinfo:
        return 1;
      case Origen.igafom:
        return 2;
      case Origen.verificada:
        return 3;
      case Origen.desconocido:
        return 0;
    }
  }

  /// Etiqueta legible asociada al origen.
  String get label {
    switch (this) {
      case Origen.reinfo:
        return 'Reinfo';
      case Origen.igafom:
        return 'IGAFOM';
      case Origen.verificada:
        return 'Verificada';
      case Origen.desconocido:
        return 'Desconocido';
    }
  }
}

/// Convierte el código proporcionado por la API en un [Origen].
Origen origenFromApi(int? code) {
  switch (code) {
    case 1:
      return Origen.reinfo;
    case 2:
      return Origen.igafom;
    case 3:
      return Origen.verificada;
    default:
      return Origen.desconocido;
  }
}

