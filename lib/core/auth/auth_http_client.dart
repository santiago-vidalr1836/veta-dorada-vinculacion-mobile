import 'package:flutter/widgets.dart';

import '../red/cliente_http.dart';
import 'auth_provider.dart';

/// Devuelve un [ClienteHttp] configurado con el token del usuario autenticado.
ClienteHttp authenticatedClient(BuildContext context) {
  final auth = AuthProvider.of(context);
  return ClienteHttp(token: auth.token ?? '');
}
