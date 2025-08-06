/// Provides access to compile-time environment variables.
class EnvironmentConfig {
  static const String clientId = String.fromEnvironment('CLIENT_ID');
  static const String tenantId = String.fromEnvironment('TENANT_ID');
  static const String _defaultScopes =
      String.fromEnvironment('DEFAULT_SCOPES');

  static List<String> get defaultScopes => _defaultScopes
      .split(RegExp(r'[ ,]+'))
      .where((scope) => scope.isNotEmpty)
      .toList();
}
