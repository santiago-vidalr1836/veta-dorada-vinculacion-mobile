import 'dart:io';

import 'package:flutter/material.dart';

/// Elemento que muestra un registro fotográfico con opciones para eliminarlo.
class FotoRegistroItem extends StatelessWidget {
  const FotoRegistroItem({
    super.key,
    required this.path,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.latitud,
    required this.longitud,
    this.onDelete,
  });

  /// Ruta del archivo de imagen.
  final String path;

  /// Título asociado a la fotografía.
  final String titulo;

  /// Descripción de la fotografía.
  final String descripcion;

  /// Fecha de captura de la fotografía.
  final DateTime fecha;

  /// Coordenada de latitud donde se tomó la fotografía.
  final double latitud;

  /// Coordenada de longitud donde se tomó la fotografía.
  final double longitud;

  /// Callback ejecutado al pulsar el botón de eliminar.
  final VoidCallback? onDelete;

  String _formatFecha(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    final hh = date.hour.toString().padLeft(2, '0');
    final mi = date.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy $hh:$mi';
  }

  @override
  Widget build(BuildContext context) {
    final tituloMostrar = titulo.isEmpty ? 'Sin título' : titulo;
    final descripcionMostrar =
        descripcion.isEmpty ? 'Sin descripción' : descripcion;
    final fechaMostrar = _formatFecha(fecha);
    final coordenadasMostrar =
        '(${latitud.toStringAsFixed(4)}, ${longitud.toStringAsFixed(4)})';

    return ListTile(
      leading: Image.file(
        File(path),
        width: 56,
        height: 56,
        fit: BoxFit.cover,
      ),
      title: Text(tituloMostrar),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(descripcionMostrar),
          Text(fechaMostrar),
          Text(coordenadasMostrar),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}

