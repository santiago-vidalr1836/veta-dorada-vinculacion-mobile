import 'package:flutter/foundation.dart';

/// Provides access to compile-time environment variables.
class EnvironmentConfig {
  static const _clientIdKey = 'CLIENT_ID';
  static const _tenantIdKey = 'TENANT_ID';
  static const _defaultScopesKey = 'DEFAULT_SCOPES';

  static String get clientId => _read(_clientIdKey);

  /// Tenant identifier for Azure AD authentication.
  static String get tenantId => _read(_tenantIdKey);

  /// Default scopes requested during authentication.
  static List<String> get defaultScopes =>
      _read(_defaultScopesKey)
          .split(RegExp(r'[ ,]+'))
          .where((scope) => scope.isNotEmpty)
          .toList();

  static String _read(String key) {
    final value = const String.fromEnvironment(key);
    if (value.isEmpty && kDebugMode) {
      debugPrint('$key is not set');
    }
    return value;
  }
}
