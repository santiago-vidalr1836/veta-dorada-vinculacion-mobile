import 'package:flutter/material.dart';

import '../../../../core/auth/auth_http_client.dart';
import '../../datos/fuentes_datos/documento_remote_data_source.dart';
import '../../datos/repositorios/flow_repository_impl.dart';
import '../../dominio/casos_uso/completar_flujo.dart';
import '../../dominio/entidades/completar_visita_comando.dart';
import '../../dominio/entidades/descripcion.dart';
import '../../dominio/entidades/evaluacion.dart';
import '../../dominio/entidades/estimacion.dart';
import '../../dominio/entidades/proveedor_snapshot.dart';
import '../../dominio/entidades/actividad.dart' as actividad_cmd;

/// Página final del flujo donde se envían los datos recopilados.
class ResumenPage extends StatefulWidget {
  const ResumenPage({super.key, required this.repository});

  final FlowRepositoryImpl repository;

  @override
  State<ResumenPage> createState() => _ResumenPageState();
}

class _ResumenPageState extends State<ResumenPage> {
  late final CompletarFlujo _completarFlujo;
  bool _initialized = false;

  bool _enviando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final documento = DocumentoRemoteDataSource(authenticatedClient(context));
    _completarFlujo = CompletarFlujo(documento, widget.repository);
    _initialized = true;
  }

  Future<bool> _formulariosCompletos() async {
    // TODO: Verificar que todos los formularios del flujo estén completos.
    return true;
  }

  Future<void> _enviarDatos() async {
    if (!await _formulariosCompletos()) return;

    setState(() => _enviando = true);

    final comando = CompletarVisitaComando(
      idVisita: 0,
      proveedor: ProveedorSnapshot(
        tipoPersona: '',
        nombre: '',
        inicioFormalizacion: false,
      ),
      actividad: actividad_cmd.Actividad(
        idTipoActividad: 0,
        idSubTipoActividad: 0,
        utmEste: 0,
        utmNorte: 0,
      ),
      descripcion: const Descripcion(
        coordenadas: '',
        zona: '',
        actividad: '',
        equipos: '',
        trabajadores: '',
        condicionesLaborales: '',
      ),
      evaluacion: const Evaluacion(idCondicionProspecto: 0, anotacion: ''),
      estimacion: const Estimacion(
        capacidadDiaria: 0,
        diasOperacion: 0,
        produccionEstimada: 0,
      ),
      fotos: const [],
    );

    try {
      await _completarFlujo(comando);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos enviados correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar datos')),
      );
    } finally {
      if (mounted) {
        setState(() => _enviando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumen')),
      body: Center(
        child: ElevatedButton(
          onPressed: _enviando ? null : _enviarDatos,
          child: _enviando
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Enviar datos'),
        ),
      ),
    );
  }
}

