import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../actividad/dominio/entidades/actividad.dart';
import '../../dominio/entidades/registro_fotografico.dart';
import '../../dominio/repositorios/flow_repository.dart';
import '../widgets/foto_registro_item.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/entidades/foto.dart';
import '../../dominio/calcular_avance.dart';

/// Página para registrar fotografías durante la verificación.
///
/// Permite capturar imágenes, agregar título y descripción y
/// guarda la información junto a la ubicación y fecha de captura.
class RegistroFotograficoVerificacionPagina extends StatefulWidget {
  const RegistroFotograficoVerificacionPagina({
    super.key,
    required this.actividad,
    required this.flagMedicionCapacidad,
    required this.flowRepository,
    required this.dto,
  });

  final Actividad actividad;
  final bool flagMedicionCapacidad;
  final FlowRepository flowRepository;
  final RealizarVerificacionDto dto;

  @override
  State<RegistroFotograficoVerificacionPagina> createState() =>
      _RegistroFotograficoVerificacionPaginaState();
}

class _RegistroFotograficoVerificacionPaginaState
    extends State<RegistroFotograficoVerificacionPagina> {
  final ImagePicker _picker = ImagePicker();
  final List<RegistroFotografico> _fotos = [];

  static const int _totalPasos = totalPasosVerificacion;
  double _avance = 0;

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
                final registro = RegistroFotografico(
                  path: saved.path,
                  titulo: tituloController.text,
                  descripcion: descripcionController.text,
                  fecha: now,
                  latitud: position.latitude,
                  longitud: position.longitude,
                );
                await widget.flowRepository.agregarFotoVerificacion(registro);
                await _cargarFotos();
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
    await widget.flowRepository.eliminarFotoVerificacion(index);
    await _cargarFotos();
  }

  void _siguiente() {
    context.push('/flujo-visita/evaluacion-labor',
        extra: {
          'actividad': widget.actividad,
          'flagMedicionCapacidad': widget.flagMedicionCapacidad,
        });
  }

  Future<void> _cargarFotos() async {
    final fotos = await widget.flowRepository.obtenerFotosVerificacion();
    setState(() {
      _fotos
        ..clear()
        ..addAll(fotos);
      final dtoActualizado = _dtoConFotos(_fotos);
      _avance = calcularAvance(dtoActualizado);
    });
  }

  RealizarVerificacionDto _dtoConFotos(List<RegistroFotografico> fotos) {
    return RealizarVerificacionDto(
      idVerificacion: widget.dto.idVerificacion,
      idVisita: widget.dto.idVisita,
      idUsuario: widget.dto.idUsuario,
      fechaInicioMovil: widget.dto.fechaInicioMovil,
      fechaFinMovil: widget.dto.fechaFinMovil,
      proveedorSnapshot: widget.dto.proveedorSnapshot,
      actividades: widget.dto.actividades,
      descripcion: widget.dto.descripcion,
      evaluacion: widget.dto.evaluacion,
      estimacion: widget.dto.estimacion,
      fotos: fotos
          .map((f) => Foto(
                imagen: f.path,
                titulo: f.titulo,
                descripcion: f.descripcion,
                fecha: f.fecha,
                latitud: f.latitud,
                longitud: f.longitud,
              ))
          .toList(),
      idempotencyKey: widget.dto.idempotencyKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro Fotográfico')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
                child: Text('${(_avance * _totalPasos).round()} de '
                    '$_totalPasos')),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: _avance),
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
