import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';

/// Remote data source that interacts with Azure AD through `flutter_appauth`.
class AzureAuthRemoteDataSource {
  AzureAuthRemoteDataSource._(this._appAuth);

  static AzureAuthRemoteDataSource create({FlutterAppAuth? appAuth}) {
    final instance = appAuth ?? FlutterAppAuth();
    return AzureAuthRemoteDataSource._(instance);
  }

  final FlutterAppAuth _appAuth;
  String? _refreshToken;
  String? _idToken;

  /// Initiates the interactive login flow and returns the access token.
  Future<String> login() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          EnvironmentConfig.clientId,
          EnvironmentConfig.redirectUri,
          scopes: EnvironmentConfig.defaultScopes,
          issuer: EnvironmentConfig.issuer,
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
    } on Exception catch (e) {
      throw AzureAuthException('Failed to logout: $e');
    }
  }

  /// Attempts to silently acquire a new access token using the refresh token.
  Future<String> refreshToken() async {
    try {
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
