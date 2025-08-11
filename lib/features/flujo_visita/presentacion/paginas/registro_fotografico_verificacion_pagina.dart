import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../actividad/dominio/entidades/actividad.dart';
import '../widgets/foto_registro_item.dart';

/// Página para registrar fotografías durante la verificación.
///
/// Permite capturar imágenes, agregar título y descripción y
/// guarda la información junto a la ubicación y fecha de captura.
class RegistroFotograficoVerificacionPagina extends StatefulWidget {
  const RegistroFotograficoVerificacionPagina({
    super.key,
    required this.actividad,
  });

  final Actividad actividad;

  @override
  State<RegistroFotograficoVerificacionPagina> createState() =>
      _RegistroFotograficoVerificacionPaginaState();
}

class _RegistroFotograficoVerificacionPaginaState
    extends State<RegistroFotograficoVerificacionPagina> {
  final ImagePicker _picker = ImagePicker();
  final List<_FotoRegistro> _fotos = [];

  Future<void> _agregarFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final position = await Geolocator.getCurrentPosition();
    final now = DateTime.now();
    final directory = await getApplicationDocumentsDirectory();
    final newPath = p.join(directory.path, '${now.millisecondsSinceEpoch}.jpg');
    final saved = await File(image.path).copy(newPath);

    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalles de la foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(
                File(saved.path),
                height: 100,
                fit: BoxFit.cover,
              ),
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                saved.deleteSync();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _fotos.add(
                    _FotoRegistro(
                      path: saved.path,
                      titulo: tituloController.text,
                      descripcion: descripcionController.text,
                      fecha: now,
                      latitud: position.latitude,
                      longitud: position.longitude,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarFoto(int index) {
    final foto = _fotos.removeAt(index);
    final file = File(foto.path);
    if (file.existsSync()) {
      file.deleteSync();
    }
    setState(() {});
  }

  void _siguiente() {
    context.push('/flujo-visita/datos-proveedor', extra: widget.actividad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro Fotográfico')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Center(child: Text('6 de 9')),
            const SizedBox(height: 8),
            const LinearProgressIndicator(value: 6 / 9),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _agregarFoto,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Añadir foto'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _fotos.isEmpty
                  ? const Center(child: Text('Sin fotos registradas'))
                  : ListView.builder(
                      itemCount: _fotos.length,
                      itemBuilder: (context, index) {
                        final foto = _fotos[index];
                        return FotoRegistroItem(
                          path: foto.path,
                          titulo: foto.titulo,
                          descripcion: foto.descripcion,
                          fecha: foto.fecha,
                          latitud: foto.latitud,
                          longitud: foto.longitud,
                          onDelete: () => _eliminarFoto(index),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _fotos.isNotEmpty ? _siguiente : null,
                child: const Text('Siguiente'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FotoRegistro {
  _FotoRegistro({
    required this.path,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.latitud,
    required this.longitud,
  });

  final String path;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final double latitud;
  final double longitud;
}
