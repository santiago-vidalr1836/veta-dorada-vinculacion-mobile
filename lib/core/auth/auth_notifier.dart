import 'package:flutter/material.dart';

import '../../features/perfil/datos/modelos/usuario.dart';

/// Mantiene el estado de autenticación del usuario.
class AuthNotifier extends ChangeNotifier {
  Usuario? _usuario;
  String? _token;

  /// Usuario actualmente autenticado.
  Usuario? get usuario => _usuario;

  /// Token de acceso del usuario.
  String? get token => _token;

  /// Indica si existe una sesión activa.
  bool get isAuthenticated => _usuario != null && _token != null;

  /// Establece los datos de autenticación y notifica a los oyentes.
  void setAuthData({required Usuario usuario, required String token}) {
    _usuario = usuario;
    _token = token;
    notifyListeners();
  }

  /// Limpia la información de la sesión.
  void clear() {
    _usuario = null;
    _token = null;
    notifyListeners();
  }
}
