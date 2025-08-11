import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return DateFormat('dd/MM/yy HH:mm').format(date);
  }

  String _formatCoordenada(double valor, {required bool esLatitud}) {
    final direccion = valor >= 0
        ? (esLatitud ? 'N' : 'E')
        : (esLatitud ? 'S' : 'O');
    final valorAbs = valor.abs();
    final grados = valorAbs.truncate();
    final minutos = (valorAbs - grados) * 60;
    return '$grados° ${minutos.toStringAsFixed(5)}\' $direccion';
  }

  @override
  Widget build(BuildContext context) {
    final tituloMostrar = titulo.isEmpty ? 'Sin título' : titulo;
    final descripcionMostrar =
        descripcion.isEmpty ? 'Sin descripción' : descripcion;
    final fechaMostrar = _formatFecha(fecha);
    final coordenadasMostrar =
        '${_formatCoordenada(latitud, esLatitud: true)}, ${_formatCoordenada(longitud, esLatitud: false)}';
    final infoMostrar = '$fechaMostrar - $coordenadasMostrar';

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
          Text(infoMostrar),
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

