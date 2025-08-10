enum OrigenActividad {
  reinfo,
  igafom,
  verificada,
  desconocido,
}

extension OrigenActividadApi on OrigenActividad {
  int toApi() {
    switch (this) {
      case OrigenActividad.reinfo:
        return 1;
      case OrigenActividad.igafom:
        return 2;
      case OrigenActividad.verificada:
        return 3;
      case OrigenActividad.desconocido:
        return 0;
    }
  }

  String get label {
    switch (this) {
      case OrigenActividad.reinfo:
        return 'Reinfo';
      case OrigenActividad.igafom:
        return 'IGAFOM';
      case OrigenActividad.verificada:
        return 'Verificada';
      case OrigenActividad.desconocido:
        return 'Desconocido';
    }
  }
}

OrigenActividad origenFromApi(int? code) {
  switch (code) {
    case 1:
      return OrigenActividad.reinfo;
    case 2:
      return OrigenActividad.igafom;
    case 3:
      return OrigenActividad.verificada;
    default:
      return OrigenActividad.desconocido;
  }
}
