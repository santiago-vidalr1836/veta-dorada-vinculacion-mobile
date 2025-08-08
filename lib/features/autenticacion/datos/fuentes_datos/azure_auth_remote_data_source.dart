import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';

/// Remote data source that interacts with Azure AD through `flutter_appauth`.
class AzureAuthRemoteDataSource {
  AzureAuthRemoteDataSource._(this._appAuth, this._secureStorage);

  static AzureAuthRemoteDataSource create({
    FlutterAppAuth? appAuth,
    FlutterSecureStorage? secureStorage,
  }) {
    final instance = appAuth ?? FlutterAppAuth();
    final storage = secureStorage ?? const FlutterSecureStorage();
    return AzureAuthRemoteDataSource._(instance, storage);
  }

  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _secureStorage;
  String? _refreshToken;
  String? _idToken;

  /// Loads tokens stored in the secure storage into memory.
  Future<void> loadFromStorage() async {
    _refreshToken = await _secureStorage.read(key: 'refreshToken');
    _idToken = await _secureStorage.read(key: 'idToken');
  }

  /// Initiates the interactive login flow and returns the access token.
  Future<String> login() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          EnvironmentConfig.clientId,
          EnvironmentConfig.redirectUri,
          scopes: EnvironmentConfig.defaultScopes,
          discoveryUrl: EnvironmentConfig.discoveryUrl.isNotEmpty
              ? EnvironmentConfig.discoveryUrl
              : null,
        ),
      );
      _refreshToken = result?.refreshToken;
      _idToken = result?.idToken;

      final accessToken = result?.accessToken;
      if (accessToken == null) {
        throw AzureAuthException('Failed to login: no access token');
      }
      await _secureStorage.write(key: 'accessToken', value: accessToken);
      final expiry = result?.accessTokenExpirationDateTime;
      if (expiry != null) {
        await _secureStorage.write(
          key: 'accessTokenExpiry',
          value: expiry.toIso8601String(),
        );
      }
      if (_refreshToken != null) {
        await _secureStorage.write(key: 'refreshToken', value: _refreshToken);
      }
      if (_idToken != null) {
        await _secureStorage.write(key: 'idToken', value: _idToken);
      }
      return accessToken;
    } on Exception catch (e) {
      throw AzureAuthException('Failed to login: $e');
    }
  }

  /// Clears the current session from the client application.
  Future<void> logout() async {
    try {
      await _appAuth.endSession(
        EndSessionRequest(
          idTokenHint: _idToken,
          postLogoutRedirectUrl: EnvironmentConfig.endSessionRedirectUri,
          issuer: EnvironmentConfig.issuer,
          discoveryUrl: EnvironmentConfig.discoveryUrl.isNotEmpty
              ? EnvironmentConfig.discoveryUrl
              : null,
        ),
      );
      _refreshToken = null;
      _idToken = null;
      await _secureStorage.delete(key: 'accessToken');
      await _secureStorage.delete(key: 'refreshToken');
      await _secureStorage.delete(key: 'idToken');
      await _secureStorage.delete(key: 'accessTokenExpiry');
    } on Exception catch (e) {
      throw AzureAuthException('Failed to logout: $e');
    }
  }

  /// Attempts to silently acquire a new access token using the refresh token.
  Future<String> refreshToken() async {
    try {
      if (_refreshToken == null) {
        await loadFromStorage();
      }
      if (_refreshToken == null) {
        throw AzureAuthException('No refresh token available');
      }
      final result = await _appAuth.token(
        TokenRequest(
          EnvironmentConfig.clientId,
          EnvironmentConfig.redirectUri,
          refreshToken: _refreshToken,
          scopes: EnvironmentConfig.defaultScopes,
          issuer: EnvironmentConfig.issuer,
          discoveryUrl: EnvironmentConfig.discoveryUrl.isNotEmpty
              ? EnvironmentConfig.discoveryUrl
              : null,
        ),
      );

      _refreshToken = result?.refreshToken ?? _refreshToken;

      final accessToken = result?.accessToken;
      if (accessToken == null) {
        throw AzureAuthException('Failed to refresh token: no access token');
      }
      await _secureStorage.write(key: 'accessToken', value: accessToken);
      final expiry = result?.accessTokenExpirationDateTime;
      if (expiry != null) {
        await _secureStorage.write(
          key: 'accessTokenExpiry',
          value: expiry.toIso8601String(),
        );
      }
      if (result?.refreshToken != null) {
        await _secureStorage.write(key: 'refreshToken', value: _refreshToken);
      }
      return accessToken;
    } on Exception catch (e) {
      throw AzureAuthException('Failed to refresh token: $e');
    }
  }
}

/// Wrapper exception thrown when authentication fails.
class AzureAuthException implements Exception {
  AzureAuthException(this.message);

  final String message;

  @override
  String toString() => 'AzureAuthException: $message';
}
