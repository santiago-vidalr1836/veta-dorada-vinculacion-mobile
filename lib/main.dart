import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/auth/auth_notifier.dart';
import 'core/auth/auth_provider.dart';
import 'core/red/cliente_http.dart';
import 'features/autenticacion/datos/fuentes_datos/azure_auth_remote_data_source.dart';
import 'features/perfil/datos/fuentes_datos/perfil_remote_data_source.dart';
import 'core/servicios/servicio_bd_local.dart';
import 'features/flujo_visita/datos/fuentes_datos/general_local_data_source.dart';
import 'features/flujo_visita/datos/fuentes_datos/general_remote_data_source.dart';
import 'features/flujo_visita/datos/repositorios/general_repository.dart';
import 'features/actividad/datos/fuentes_datos/tipo_actividad_local_data_source.dart';
import 'features/actividad/datos/fuentes_datos/tipo_actividad_remote_data_source.dart';
import 'features/actividad/datos/repositorios/actividad_repository_impl.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  final authNotifier = AuthNotifier();
  await initAuth(authNotifier);
  await _sincronizarListas(authNotifier);
  runApp(VinculacionApp(authNotifier: authNotifier));
}

Future<void> initAuth(
  AuthNotifier authNotifier, {
  dynamic Function(FlutterSecureStorage storage)? authDataSourceBuilder,
  dynamic Function(String token)? perfilDataSourceBuilder,
}) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'accessToken');
  final refreshToken = await storage.read(key: 'refreshToken');
  final expiryStr = await storage.read(key: 'accessTokenExpiry');
  var currentToken = token;
  final expiry = expiryStr != null ? DateTime.tryParse(expiryStr) : null;
  final shouldRefresh =
      currentToken == null ||
      expiry == null ||
      expiry.isBefore(DateTime.now().add(const Duration(minutes: 1)));
  if (shouldRefresh) {
    if (refreshToken == null) {
      await _clearSession(storage, authNotifier);
      return;
    }
    try {
      final authRemoteDataSource =
          (authDataSourceBuilder ??
              (s) => AzureAuthRemoteDataSource.create(secureStorage: s))(storage);
      await authRemoteDataSource.loadFromStorage();
      currentToken = await authRemoteDataSource.refreshToken();
    } catch (_) {
      await _clearSession(storage, authNotifier);
      return;
    }
  }
  if (currentToken == null) {
    await _clearSession(storage, authNotifier);
    return;
  }
  var perfilDataSource =
      (perfilDataSourceBuilder ??
          (t) => PerfilRemoteDataSource(ClienteHttp(token: t)))(currentToken);
  try {
    final respuesta = await perfilDataSource.obtenerPerfil();
    if (respuesta.codigoRespuesta == RespuestaBase.RESPUESTA_CORRECTA &&
        respuesta.respuesta != null) {
      authNotifier.setAuthData(
          usuario: respuesta.respuesta!, token: currentToken);
      return;
    } else {
      await _clearSession(storage, authNotifier);
      return;
    }
  } catch (_) {
    if (refreshToken == null) {
      await _clearSession(storage, authNotifier);
      return;
    }
    try {
      final authRemoteDataSource =
          (authDataSourceBuilder ??
              (s) => AzureAuthRemoteDataSource.create(secureStorage: s))(storage);
      await authRemoteDataSource.loadFromStorage();
      final newToken = await authRemoteDataSource.refreshToken();
      currentToken = newToken;
      perfilDataSource =
          (perfilDataSourceBuilder ??
              (t) => PerfilRemoteDataSource(ClienteHttp(token: t)))(newToken);
      final respuesta = await perfilDataSource.obtenerPerfil();
      if (respuesta.codigoRespuesta == RespuestaBase.RESPUESTA_CORRECTA &&
          respuesta.respuesta != null) {
        authNotifier.setAuthData(
            usuario: respuesta.respuesta!, token: newToken);
      } else {
        await _clearSession(storage, authNotifier);
      }
    } catch (_) {
      await _clearSession(storage, authNotifier);
    }
  }
}

Future<void> _sincronizarListas(AuthNotifier authNotifier) async {
  final token = authNotifier.token;
  if (token == null) return;
  final repo = GeneralRepository(
    GeneralRemoteDataSource(ClienteHttp(token: token)),
    GeneralLocalDataSource(ServicioBdLocal()),
  );
  await repo.sincronizarDatosGenerales();

  final actividadRepo = ActividadRepositoryImpl(
    TipoActividadRemoteDataSource(ClienteHttp(token: token)),
    TipoActividadLocalDataSource(ServicioBdLocal()),
  );
  await actividadRepo.sincronizarTiposActividad();
}

Future<void> _clearSession(
    FlutterSecureStorage storage, AuthNotifier authNotifier) async {
  await storage.delete(key: 'accessToken');
  await storage.delete(key: 'refreshToken');
  await storage.delete(key: 'accessTokenExpiry');
  authNotifier.clear();
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
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: createRouter(authNotifier),
      ),
    );
  }
}
