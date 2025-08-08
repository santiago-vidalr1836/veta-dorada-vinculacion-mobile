import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/auth/auth_notifier.dart';
import 'core/auth/auth_provider.dart';
import 'core/red/cliente_http.dart';
import 'features/autenticacion/datos/fuentes_datos/azure_auth_remote_data_source.dart';
import 'features/perfil/datos/fuentes_datos/perfil_remote_data_source.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authNotifier = AuthNotifier();
  await _initAuth(authNotifier);
  runApp(VinculacionApp(authNotifier: authNotifier));
}

Future<void> _initAuth(AuthNotifier authNotifier) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'accessToken');
  final refreshToken = await storage.read(key: 'refreshToken');
  final expiryStr = await storage.read(key: 'accessTokenExpiry');
  if (token == null) return;
  var currentToken = token;
  final expiry = expiryStr != null ? DateTime.tryParse(expiryStr) : null;
  if (expiry == null ||
      expiry.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
    if (refreshToken == null) {
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');
      await storage.delete(key: 'accessTokenExpiry');
      authNotifier.clear();
      return;
    }
    final authRemoteDataSource =
        AzureAuthRemoteDataSource.create(secureStorage: storage);
    await authRemoteDataSource.loadFromStorage();
    try {
      currentToken = await authRemoteDataSource.refreshToken();
    } catch (_) {
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');
      await storage.delete(key: 'accessTokenExpiry');
      authNotifier.clear();
      return;
    }
  }
  var client = ClienteHttp(token: currentToken);
  var perfilDataSource = PerfilRemoteDataSource(client);
  try {
    final usuario = await perfilDataSource.obtenerPerfil();
    authNotifier.setAuthData(usuario: usuario, token: currentToken);
  } catch (_) {
    if (refreshToken == null) {
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');
      await storage.delete(key: 'accessTokenExpiry');
      authNotifier.clear();
      return;
    }
    final authRemoteDataSource =
        AzureAuthRemoteDataSource.create(secureStorage: storage);
    await authRemoteDataSource.loadFromStorage();
    try {
      final newToken = await authRemoteDataSource.refreshToken();
      client = ClienteHttp(token: newToken);
      perfilDataSource = PerfilRemoteDataSource(client);
      final usuario = await perfilDataSource.obtenerPerfil();
      authNotifier.setAuthData(usuario: usuario, token: newToken);
    } catch (_) {
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');
      await storage.delete(key: 'accessTokenExpiry');
      authNotifier.clear();
    }
  }
}

class VinculacionApp extends StatelessWidget {
  const VinculacionApp({super.key, required this.authNotifier});

  final AuthNotifier authNotifier;

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      notifier: authNotifier,
      child: MaterialApp.router(
        title: 'MineCheck',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: createRouter(authNotifier),
      ),
    );
  }
}
