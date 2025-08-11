import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

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
  static const _prefsKey = 'fotos_verificacion';

  @override
  void initState() {
    super.initState();
    _cargarFotos();
  }

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
              onPressed: () async {
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
                await _guardarFotos();
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarFoto(int index) async {
    try {
      await File(_fotos[index].path).delete();
    } catch (e) {
      debugPrint('Error al eliminar foto: $e');
    }
    setState(() => _fotos.removeAt(index));
    await _guardarFotos();
  }

  void _siguiente() {
    context.push('/flujo-visita/evaluacion-labor', extra: widget.actividad);
  }

  Future<void> _guardarFotos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(_fotos.map((e) => e.toJson()).toList());
    await prefs.setString(_prefsKey, jsonString);
  }

  Future<void> _cargarFotos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString == null) return;
    final List<dynamic> data = jsonDecode(jsonString);
    setState(() {
      _fotos
        ..clear()
        ..addAll(data.map((e) => _FotoRegistro.fromJson(e as Map<String, dynamic>)));
    });
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

  Map<String, dynamic> toJson() => {
        'path': path,
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha.toIso8601String(),
        'latitud': latitud,
        'longitud': longitud,
      };

  factory _FotoRegistro.fromJson(Map<String, dynamic> json) => _FotoRegistro(
        path: json['path'] as String,
        titulo: json['titulo'] as String,
        descripcion: json['descripcion'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
        latitud: (json['latitud'] as num).toDouble(),
        longitud: (json['longitud'] as num).toDouble(),
      );
}
