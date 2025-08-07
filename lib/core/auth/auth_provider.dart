import 'package:flutter/material.dart';

import 'auth_notifier.dart';

/// Widget que expone [AuthNotifier] en el árbol de widgets.
class AuthProvider extends InheritedNotifier<AuthNotifier> {
  const AuthProvider({
    super.key,
    required AuthNotifier notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  /// Obtiene el [AuthNotifier] más cercano en el árbol.
  static AuthNotifier of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    assert(provider != null, 'No AuthProvider found in context');
    return provider!.notifier!;
  }
}
