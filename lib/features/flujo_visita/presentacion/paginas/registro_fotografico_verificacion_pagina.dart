import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../actividad/dominio/entidades/actividad.dart';
import '../../dominio/entidades/registro_fotografico.dart';
import '../widgets/foto_registro_item.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/entidades/foto.dart';
import '../../dominio/calcular_avance.dart';
import '../../dominio/repositorios/verificacion_repository.dart';
import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';
import '../../../../core/widgets/bottom_nav_actions.dart';

/// Página para registrar fotografías durante la verificación.
///
/// Permite capturar imágenes, agregar título y descripción y
/// guarda la información junto a la ubicación y fecha de captura.
class RegistroFotograficoVerificacionPagina extends StatefulWidget {
  const RegistroFotograficoVerificacionPagina({
    super.key,
    required this.actividad,
    required this.flagMedicionCapacidad,
    required this.flagEstimacionProduccion,
    required this.verificacionRepository,
    required this.dto,
  });

  final Actividad actividad;
  final bool flagMedicionCapacidad;
  final bool flagEstimacionProduccion;
  final VerificacionRepository verificacionRepository;
  final RealizarVerificacionDto dto;

  @override
  State<RegistroFotograficoVerificacionPagina> createState() =>
      _RegistroFotograficoVerificacionPaginaState();
}

class _RegistroFotograficoVerificacionPaginaState
    extends State<RegistroFotograficoVerificacionPagina> {
  final ImagePicker _picker = ImagePicker();
  final List<RegistroFotografico> _fotos = [];
  late RealizarVerificacionDto _dto;

  static const int _totalPasos = totalPasosVerificacion;
  double _avance = 0;

  @override
  void initState() {
    super.initState();
    _dto = widget.dto;
    if(_dto.fotos!=null) {
      _fotos.addAll(
        _dto.fotos!.map(
              (f) =>
              RegistroFotografico(
                path: f.imagen,
                titulo: f.titulo,
                descripcion: f.descripcion,
                fecha: f.fecha,
                latitud: f.latitud,
                longitud: f.longitud,
              ),
        ),
      );
    }
    _avance = calcularAvance(_dto);
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
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
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
                setState(() {
                  _fotos.add(registro);
                  _dto = _dtoConFotos(_fotos);
                  _avance = calcularAvance(_dto);
                });
                await widget.verificacionRepository.guardarVerificacion(_dto);
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
    setState(() {
      _fotos.removeAt(index);
      _dto = _dtoConFotos(_fotos);
      _avance = calcularAvance(_dto);
    });
    await widget.verificacionRepository.guardarVerificacion(_dto);
  }

  Future<void> _siguiente() async {
    if (_fotos.isEmpty) return;
    await widget.verificacionRepository.guardarVerificacion(_dto);
    if (!mounted) return;
    context.push('/flujo-visita/evaluacion-labor', extra: {
      'actividad': widget.actividad,
      'flagMedicionCapacidad': widget.flagMedicionCapacidad,
      'flagEstimacionProduccion': widget.flagEstimacionProduccion,
      'dto': _dto,
    });
  }

  RealizarVerificacionDto _dtoConFotos(List<RegistroFotografico> fotos) {
    return RealizarVerificacionDto(
      idVerificacion: _dto.idVerificacion,
      idVisita: _dto.idVisita,
      idUsuario: _dto.idUsuario,
      fechaInicioMovil: _dto.fechaInicioMovil,
      fechaFinMovil: _dto.fechaFinMovil,
      proveedorSnapshot: _dto.proveedorSnapshot,
      actividades: _dto.actividades,
      descripcion: _dto.descripcion,
      evaluacion: _dto.evaluacion,
      estimacion: _dto.estimacion,
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
      idempotencyKey: _dto.idempotencyKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return ProtectedScaffold(
      usuario: auth.usuario!,
      token: auth.token!,
      onNavigate: (ruta) => context.go(ruta),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              width: 378,
              child: Text(
                'Registro Fotográfico',
                style: TextStyle(
                  color: Color(0xFF1D1B20),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 1.27,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
          ],
        ),
      ),
      bottomBar: BottomNavActions(
        onNext: _siguiente,
        onBack: () => context.pop(),
      ),
    );
  }
}
