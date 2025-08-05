import 'package:flutter/material.dart';
import 'package:msal_flutter/msal_flutter.dart';

/// Pantalla de inicio de sesión basada en Microsoft Entra.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final PublicClientApplication _pca;

  @override
  void initState() {
    super.initState();
    // TODO: Reemplazar con el clientId real de la aplicación.
    _pca = PublicClientApplication(
      'REEMPLAZAR_CON_CLIENT_ID',
      authority: 'https://login.microsoftonline.com/common',
    );
  }

  Future<void> _signIn() async {
    try {
      await _pca.acquireTokenInteractive(scopes: const ['User.Read']);
    } catch (e) {
      // Manejar errores o cancelaciones del flujo de autenticación.
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

