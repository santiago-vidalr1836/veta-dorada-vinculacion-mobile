import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veta_dorada_vinculacion_mobile/features/autenticacion/datos/fuentes_datos/azure_auth_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/presentacion/paginas/visitas_tabs_page.dart';

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
      await _authRemoteDataSource.login();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const VisitasTabsPage()),
      );
    } on AzureAuthException catch (e) {
      if (!mounted) return;
      final snackBar = SnackBar(content: Text(e.message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (e) {
      debugPrint('code=${e.code} message=${e.message} details=${e.details}');
    }catch (e) {
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

