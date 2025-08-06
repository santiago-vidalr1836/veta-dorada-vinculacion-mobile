import 'package:flutter_test/flutter_test.dart';
import 'package:veta_dorada_vinculacion_mobile/features/autenticacion/datos/fuentes_datos/azure_auth_remote_data_source.dart';

class _FakePca {
  bool shouldThrow = false;
  String token = 'token';

  Future<String> acquireTokenInteractive({required List<String> scopes}) async {
    if (shouldThrow) throw Exception('error');
    return token;
  }

  Future<String> acquireTokenSilent({required List<String> scopes}) async {
    if (shouldThrow) throw Exception('error');
    return token;
  }

  Future<void> logout() async {
    if (shouldThrow) throw Exception('error');
  }
}

void main() {
  group('AzureAuthRemoteDataSource', () {
    late _FakePca fakePca;
    late AzureAuthRemoteDataSource dataSource;

    setUp(() {
      fakePca = _FakePca();
      dataSource = AzureAuthRemoteDataSource(pca: fakePca);
    });

    test('login returns token on success', () async {
      fakePca.shouldThrow = false;
      final token = await dataSource.login();
      expect(token, fakePca.token);
    });

    test('login throws AzureAuthException on failure', () async {
      fakePca.shouldThrow = true;
      expect(dataSource.login, throwsA(isA<AzureAuthException>()));
    });

    test('refreshToken returns token on success', () async {
      fakePca.shouldThrow = false;
      final token = await dataSource.refreshToken();
      expect(token, fakePca.token);
    });

    test('refreshToken throws AzureAuthException on failure', () async {
      fakePca.shouldThrow = true;
      expect(dataSource.refreshToken, throwsA(isA<AzureAuthException>()));
    });
  });
}
