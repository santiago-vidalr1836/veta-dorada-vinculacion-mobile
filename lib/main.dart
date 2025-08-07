import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/red/cliente_http.dart';
import 'features/autenticacion/presentacion/paginas/login_page.dart';
import 'features/perfil/datos/fuentes_datos/perfil_remote_data_source.dart';
import 'features/visitas/presentacion/paginas/visitas_tabs_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = const FlutterSecureStorage();
  final accessToken = await storage.read(key: 'accessToken');

  Widget initialPage = const LoginPage();
  if (accessToken != null) {
    final client = ClienteHttp(token: accessToken);
    final perfilDataSource = PerfilRemoteDataSource(client);
    try {
      await perfilDataSource.obtenerPerfil();
      initialPage = const VisitasTabsPage();
    } catch (_) {
      // Fall back to login on any error.
    }
  }

  runApp(VinculacionApp(initialPage: initialPage));
}

class VinculacionApp extends StatelessWidget {
  const VinculacionApp({super.key, required this.initialPage});

  final Widget initialPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MineCheck',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: initialPage,
    );
  }
}

