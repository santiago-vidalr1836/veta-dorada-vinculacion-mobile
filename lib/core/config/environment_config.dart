import 'package:flutter/foundation.dart';

/// Provides access to compile-time environment variables.
class EnvironmentConfig {
  static String get clientId {
    const clientId = String.fromEnvironment('CLIENT_ID');
    if (clientId.isEmpty && kDebugMode) {
      debugPrint('CLIENT_ID is not set');
    }
    return clientId;
  }

  /// Tenant identifier for Azure AD authentication.
  static String get tenantId {
    const tenantId = String.fromEnvironment('TENANT_ID');
    if (tenantId.isEmpty && kDebugMode) {
      debugPrint('TENANT_ID is not set');
    }
    return tenantId;
  }

  /// Default scopes requested during authentication.
  static List<String> get defaultScopes {
    const scopes = String.fromEnvironment('DEFAULT_SCOPES');
    if (scopes.isEmpty && kDebugMode) {
      debugPrint('DEFAULT_SCOPES is not set');
    }
    return scopes
        .split(RegExp(r'[ ,]+'))
        .where((scope) => scope.isNotEmpty)
        .toList();
  }
}
