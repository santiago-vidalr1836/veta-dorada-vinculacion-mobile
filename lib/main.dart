import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/auth/auth_notifier.dart';
import 'core/auth/auth_provider.dart';
import 'core/red/cliente_http.dart';
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
  if (token == null) return;
  final client = ClienteHttp(token: token);
  final perfilDataSource = PerfilRemoteDataSource(client);
  try {
    final usuario = await perfilDataSource.obtenerPerfil();
    authNotifier.setAuthData(usuario: usuario, token: token);
  } catch (_) {
    // Ignorar errores de carga inicial.
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
