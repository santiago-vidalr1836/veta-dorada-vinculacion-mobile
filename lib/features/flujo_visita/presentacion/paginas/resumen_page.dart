import 'dart:io';

import 'package:flutter/material.dart';

import '../../../datos/fuentes_datos/documento_remote_data_source.dart';
import '../../../datos/repositorios/flow_repository_impl.dart';
import '../../dominio/entidades/registro_fotografico.dart';
import '../../../../core/red/cliente_http.dart';

/// Página final del flujo donde se envían los datos recopilados.
class ResumenPage extends StatefulWidget {
  const ResumenPage({super.key});

  @override
  State<ResumenPage> createState() => _ResumenPageState();
}

class _ResumenPageState extends State<ResumenPage> {
  final FlowRepositoryImpl _repository = FlowRepositoryImpl();
  late final DocumentoRemoteDataSource _remoteDataSource;

  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    // En un escenario real el token provendría del proceso de autenticación.
    _remoteDataSource = DocumentoRemoteDataSource(ClienteHttp(token: ''));
  }

  Future<bool> _formulariosCompletos() async {
    // TODO: Verificar que todos los formularios del flujo estén completos.
    return true;
  }

  Future<void> _enviarDatos() async {
    if (!await _formulariosCompletos()) return;

    setState(() => _enviando = true);

    final fotos = await _repository.obtenerFotosVerificacion();
    final List<RegistroFotografico> actualizadas = [];

    for (final foto in fotos) {
      final file = File(foto.path);
      final url = await _remoteDataSource.subirDocumento(file);
      actualizadas.add(
        RegistroFotografico(
          path: url,
          titulo: foto.titulo,
          descripcion: foto.descripcion,
          fecha: foto.fecha,
          latitud: foto.latitud,
          longitud: foto.longitud,
        ),
      );
    }

    // TODO: Enviar `actualizadas` junto con el resto de la información.

    setState(() => _enviando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumen')),
      body: Center(
        child: _enviando
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _enviarDatos,
                child: const Text('Enviar datos'),
              ),
      ),
    );
  }
}

