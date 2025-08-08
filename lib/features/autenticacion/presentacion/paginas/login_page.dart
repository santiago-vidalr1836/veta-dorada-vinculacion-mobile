import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:veta_dorada_vinculacion_mobile/core/auth/auth_provider.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/features/autenticacion/datos/fuentes_datos/azure_auth_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/fuentes_datos/perfil_remote_data_source.dart';

/// Pantalla de inicio de sesión basada en Microsoft Entra.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AzureAuthRemoteDataSource _authRemoteDataSource =
      AzureAuthRemoteDataSource.create();

  Future<void> _signIn() async {
    try {
      final token = await _authRemoteDataSource.login();
      debugPrint(token);
      final client = ClienteHttp(token: token);
      final perfilDataSource = PerfilRemoteDataSource(client);
      final usuario = await perfilDataSource.obtenerPerfil();
      if (!mounted) return;
      AuthProvider.of(context)
          .setAuthData(usuario: usuario, token: token);
      context.go('/visitas');
    } on AzureAuthException catch (e) {
      if (!mounted) return;
      final snackBar = SnackBar(content: Text(e.message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PerfilRemoteException catch (e) {
      if (!mounted) return;
      final snackBar = SnackBar(content: Text(e.message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (e) {
      debugPrint('code=${e.code} message=${e.message} details=${e.details}');
    } catch (e) {
      if (!mounted) return;
      final snackBar = SnackBar(content: Text('Error inesperado: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const Spacer(),
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child:
                        FlutterLogo(size: constraints.maxWidth * 0.4), // Logo
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'MineCheck',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signIn,
                      child: const Text('Ingresar con Microsoft'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
