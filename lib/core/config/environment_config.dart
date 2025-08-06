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
}
