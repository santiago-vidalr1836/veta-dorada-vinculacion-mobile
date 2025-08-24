import 'package:flutter/material.dart';

/// Acciones de navegación inferior con botones "Atrás" y "Siguiente".
class BottomNavActions extends StatelessWidget {
  const BottomNavActions({
    super.key,
    this.onBack,
    required this.onNext,
    this.nextText = 'Siguiente',
    this.showBack,
  });

  /// Callback opcional que se ejecuta al presionar "Atrás".
  final VoidCallback? onBack;

  /// Callback requerido para la acción "Siguiente".
  final VoidCallback onNext;

  /// Texto del botón "Siguiente".
  final String nextText;

  /// Determina si se muestra el botón "Atrás". Si es `null`, se
  /// evalúa `Navigator.of(context).canPop()`.
  final bool? showBack;

  @override
  Widget build(BuildContext context) {
    final mostrarAtras = showBack ?? Navigator.of(context).canPop();

    return SafeArea(
      child: Row(
        children: [
          if (mostrarAtras)
            OutlinedButton.icon(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Atrás'),
            ),
          if (mostrarAtras) const Spacer(),
          if (mostrarAtras)
            ElevatedButton(
              onPressed: onNext,
              child: Text(nextText),
            )
          else
            Expanded(
              child: ElevatedButton(
                onPressed: onNext,
                child: Text(nextText),
              ),
            ),
        ],
      ),
    );
  }
}

