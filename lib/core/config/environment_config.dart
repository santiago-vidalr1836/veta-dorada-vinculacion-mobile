/// Provides access to compile-time environment variables.
///
/// These values configure the authentication flow when using
/// `flutter_appauth`. They are injected at compile time using the
/// `--dart-define` option.
class EnvironmentConfig {
  /// OAuth client identifier.
  static const String clientId = String.fromEnvironment('CLIENT_ID');

  /// Azure AD tenant identifier.
  static const String tenantId = String.fromEnvironment('TENANT_ID');

  /// Redirect URI registered for the application.
  static const String redirectUri = String.fromEnvironment('REDIRECT_URI');

  /// Issuer used for OpenID Connect discovery.
  static const String issuer = String.fromEnvironment('ISSUER');

  /// Discovery URL. Provide either [issuer] or this value when configuring
  /// `flutter_appauth`.
  static const String discoveryUrl =
      String.fromEnvironment('DISCOVERY_URL');

  /// Redirect URI used after the logout endpoint completes.
  static const String endSessionRedirectUri =
      String.fromEnvironment('END_SESSION_REDIRECT_URI');

  /// Comma or space separated list of scopes requested during authentication.
  static const String _defaultScopes =
      String.fromEnvironment('DEFAULT_SCOPES');

  /// Parsed list of default scopes.
  static List<String> get defaultScopes => _defaultScopes
      .split(RegExp(r'[ ,]+'))
      .where((scope) => scope.isNotEmpty)
      .toList();
}
