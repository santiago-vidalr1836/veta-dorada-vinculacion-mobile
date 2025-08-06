import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:veta_dorada_vinculacion_mobile/features/autenticacion/datos/fuentes_datos/azure_auth_remote_data_source.dart';

class _FakeAppAuth {
  bool shouldThrow = false;
  String accessToken = 'accessToken';
  String refreshToken = 'refreshToken';
  String idToken = 'idToken';
  String? lastRefreshToken;

  Future<AuthorizationTokenResponse> authorizeAndExchangeCode(
    AuthorizationTokenRequest request,
  ) async {
    if (shouldThrow) throw Exception('error');
    return AuthorizationTokenResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: idToken,
    );
  }

  Future<TokenResponse> token(TokenRequest request) async {
    lastRefreshToken = request.refreshToken;
    if (shouldThrow) throw Exception('error');
    if (request.refreshToken == null) throw Exception('missing refresh token');
    return TokenResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> endSession(EndSessionRequest request) async {
    if (shouldThrow) throw Exception('error');
  }
}

void main() {
  group('AzureAuthRemoteDataSource', () {
    late _FakeAppAuth fakeAppAuth;
    late AzureAuthRemoteDataSource dataSource;

    setUp(() {
      fakeAppAuth = _FakeAppAuth();
      dataSource = AzureAuthRemoteDataSource.create(appAuth: fakeAppAuth);
    });

    test('login returns token on success', () async {
      fakeAppAuth.shouldThrow = false;
      final token = await dataSource.login();
      expect(token, fakeAppAuth.accessToken);
    });

    test('login throws AzureAuthException on failure', () async {
      fakeAppAuth.shouldThrow = true;
      expect(dataSource.login, throwsA(isA<AzureAuthException>()));
    });

    test('refreshToken returns token on success', () async {
      fakeAppAuth.shouldThrow = false;
      await dataSource.login();
      fakeAppAuth.accessToken = 'newAccess';
      fakeAppAuth.refreshToken = 'newRefresh';
      final token = await dataSource.refreshToken();
      expect(token, 'newAccess');
      expect(fakeAppAuth.lastRefreshToken, 'refreshToken');
    });

    test('refreshToken throws AzureAuthException on failure', () async {
      fakeAppAuth.shouldThrow = false;
      await dataSource.login();
      fakeAppAuth.shouldThrow = true;
      expect(dataSource.refreshToken, throwsA(isA<AzureAuthException>()));
    });

    test('logout completes successfully and clears tokens', () async {
      fakeAppAuth.shouldThrow = false;
      await dataSource.login();
      await dataSource.logout();
      expect(dataSource.refreshToken, throwsA(isA<AzureAuthException>()));
    });

    test('logout throws AzureAuthException when endSession fails', () async {
      fakeAppAuth.shouldThrow = false;
      await dataSource.login();
      fakeAppAuth.shouldThrow = true;
      expect(dataSource.logout, throwsA(isA<AzureAuthException>()));
    });
  });
}
