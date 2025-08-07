import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veta_dorada_vinculacion_mobile/features/autenticacion/datos/fuentes_datos/azure_auth_remote_data_source.dart';

class _FakeAppAuth extends FlutterAppAuth {
  bool shouldThrow = false;
  String accessToken = 'accessToken';
  String refreshToken = 'refreshToken';
  String idToken = 'idToken';
  String? lastRefreshToken;

  @override
  Future<AuthorizationTokenResponse?> authorizeAndExchangeCode(
    AuthorizationTokenRequest request,
  ) async {
    if (shouldThrow) throw Exception('error');
    return AuthorizationTokenResponse(
      accessToken,
      refreshToken,
      DateTime.now(),
      idToken,
      null,
      null,
      null,
      null,
    );
  }

  @override
  Future<TokenResponse?> token(TokenRequest request) async {
    lastRefreshToken = request.refreshToken;
    if (shouldThrow) throw Exception('error');
    if (request.refreshToken == null) {
      throw Exception('missing refresh token');
    }
    return TokenResponse(
      accessToken,
      refreshToken,
      null,
      null,
      null,
      null,
      null,
    );
  }

  @override
  Future<void> endSession(EndSessionRequest request) async {
    if (shouldThrow) throw Exception('error');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage.setMockInitialValues({});

  group('AzureAuthRemoteDataSource', () {
    late _FakeAppAuth fakeAppAuth;
    late FlutterSecureStorage secureStorage;
    late AzureAuthRemoteDataSource dataSource;

    setUp(() {
      fakeAppAuth = _FakeAppAuth();
      secureStorage = const FlutterSecureStorage();
      dataSource = AzureAuthRemoteDataSource.create(
        appAuth: fakeAppAuth,
        secureStorage: secureStorage,
      );
    });

    test('login returns token on success and stores tokens', () async {
      final token = await dataSource.login();
      expect(token, fakeAppAuth.accessToken);
      expect(
        await secureStorage.read(key: 'accessToken'),
        fakeAppAuth.accessToken,
      );
      expect(
        await secureStorage.read(key: 'refreshToken'),
        fakeAppAuth.refreshToken,
      );
    });

    test('login throws AzureAuthException on failure', () async {
      fakeAppAuth.shouldThrow = true;
      expect(dataSource.login, throwsA(isA<AzureAuthException>()));
    });

    test('refreshToken returns token on success and updates storage', () async {
      await dataSource.login();
      fakeAppAuth.accessToken = 'newAccess';
      fakeAppAuth.refreshToken = 'newRefresh';
      final token = await dataSource.refreshToken();
      expect(token, 'newAccess');
      expect(fakeAppAuth.lastRefreshToken, 'refreshToken');
      expect(
        await secureStorage.read(key: 'accessToken'),
        'newAccess',
      );
      expect(
        await secureStorage.read(key: 'refreshToken'),
        'newRefresh',
      );
    });

    test('refreshToken throws AzureAuthException on failure', () async {
      await dataSource.login();
      fakeAppAuth.shouldThrow = true;
      expect(dataSource.refreshToken, throwsA(isA<AzureAuthException>()));
    });

    test('logout clears tokens from storage', () async {
      await dataSource.login();
      await dataSource.logout();
      expect(await secureStorage.read(key: 'accessToken'), isNull);
      expect(await secureStorage.read(key: 'refreshToken'), isNull);
    });

    test('logout throws AzureAuthException when endSession fails', () async {
      await dataSource.login();
      fakeAppAuth.shouldThrow = true;
      expect(dataSource.logout, throwsA(isA<AzureAuthException>()));
    });
  });
}

