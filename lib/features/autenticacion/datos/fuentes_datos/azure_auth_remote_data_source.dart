import 'package:msal_flutter/msal_flutter.dart';
import 'package:veta_dorada_vinculacion_mobile/core/config/environment_config.dart';

/// Remote data source that interacts with Azure AD through `msal_flutter`.
class AzureAuthRemoteDataSource {
  AzureAuthRemoteDataSource._(this._pca);

  static Future<AzureAuthRemoteDataSource> create({dynamic pca}) async {
    final config = PublicClientApplicationConfiguration(
      clientId: EnvironmentConfig.clientId,
      authority:
          'https://login.microsoftonline.com/${EnvironmentConfig.tenantId}',
    );
    final instance = pca ??
        await PublicClientApplication.createPublicClientApplication(config);
    return AzureAuthRemoteDataSource._(instance);
  }

  final dynamic _pca;

  /// Initiates the interactive login flow and returns the access token.
  Future<String> login() async {
    try {
      return await _pca.acquireTokenInteractive(
        scopes: EnvironmentConfig.defaultScopes,
      );
    } catch (e) {
      throw AzureAuthException('Failed to login: $e');
    }
  }

  /// Clears the current session from the client application.
  Future<void> logout() async {
    await _pca.logout();
  }

  /// Attempts to silently acquire a new access token using cached credentials.
  Future<String> refreshToken() async {
    try {
      return await _pca.acquireTokenSilent(
        scopes: EnvironmentConfig.defaultScopes,
      );
    } catch (e) {
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
