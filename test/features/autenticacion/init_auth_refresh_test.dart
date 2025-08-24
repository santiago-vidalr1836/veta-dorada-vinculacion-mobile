import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/oficina.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/perfil.dart';

import 'package:veta_dorada_vinculacion_mobile/main.dart';
import 'package:veta_dorada_vinculacion_mobile/core/auth/auth_notifier.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';

class FakeAuthRemoteDataSource {
  FakeAuthRemoteDataSource(this.storage);
  final FlutterSecureStorage storage;

  Future<void> loadFromStorage() async {}

  Future<String> refreshToken() async {
    final refresh = await storage.read(key: 'refreshToken');
    if (refresh == null) {
      throw Exception('no refresh token');
    }
    const newToken = 'new_access_token';
    await storage.write(key: 'accessToken', value: newToken);
    await storage.write(
      key: 'accessTokenExpiry',
      value: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
    );
    return newToken;
  }
}

class FakePerfilRemoteDataSource {
  Future<RespuestaBase<Usuario>> obtenerPerfil() async {
    final usuario =
        Usuario(id: 1, nombre: 'Test',apellidos: '', correo: 'test@example.com',oficina: Oficina(id: 1, nombre: ''),perfil: Perfil(id: 1, nombre: ''));
    return RespuestaBase.respuestaCorrecta(usuario);
  }
}

void main() {
  test('initAuth refreshes token and loads profile when only refresh token present', () async {
    FlutterSecureStorage.setMockInitialValues({
      'refreshToken': 'refresh_token',
    });
    final notifier = AuthNotifier();
    await initAuth(
      notifier,
      authDataSourceBuilder: (storage) => FakeAuthRemoteDataSource(storage),
      perfilDataSourceBuilder: (_) => FakePerfilRemoteDataSource(),
    );

    expect(notifier.token, 'new_access_token');
    expect(notifier.usuario, isNotNull);
    expect(notifier.usuario!.nombre, 'Test');
  });
}
