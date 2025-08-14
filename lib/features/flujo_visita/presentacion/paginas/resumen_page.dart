import 'package:flutter/material.dart';

import '../../../../core/red/cliente_http.dart';
import '../../../datos/fuentes_datos/documento_remote_data_source.dart';
import '../../../datos/fuentes_datos/verificacion_remote_data_source.dart';
import '../../../datos/repositorios/flow_repository_impl.dart';
import '../../dominio/casos_uso/completar_flujo.dart';
import '../../dominio/entidades/completar_visita_comando.dart';
import '../../dominio/entidades/descripcion.dart';
import '../../dominio/entidades/evaluacion.dart';
import '../../dominio/entidades/estimacion.dart';
import '../../dominio/entidades/foto.dart';
import '../../dominio/entidades/proveedor_snapshot.dart';
import '../../dominio/entidades/actividad.dart' as actividad_cmd;
import '../../dominio/entidades/registro_fotografico.dart';
import '../../dominio/entidades/descripcion_actividad_verificada.dart';

/// Página final del flujo donde se envían los datos recopilados.
class ResumenPage extends StatefulWidget {
  const ResumenPage({super.key});

  @override
  State<ResumenPage> createState() => _ResumenPageState();
}

class _ResumenPageState extends State<ResumenPage> {
  late final FlowRepositoryImpl _repository;
  late final CompletarFlujo _completarFlujo;

  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    // En un escenario real el token provendría del proceso de autenticación.
    final client = ClienteHttp(token: '');
    final documento = DocumentoRemoteDataSource(client);
    final verificacion = VerificacionRemoteDataSource(client);
    _repository = FlowRepositoryImpl(verificacion);
    _completarFlujo = CompletarFlujo(documento, _repository);
  }

  Future<bool> _formulariosCompletos() async {
    // TODO: Verificar que todos los formularios del flujo estén completos.
    return true;
  }

  Future<void> _enviarDatos() async {
    if (!await _formulariosCompletos()) return;

    setState(() => _enviando = true);

    final descripcion = await _repository.obtenerDescripcionActividadVerificada();
    final fotos = await _repository.obtenerFotosVerificacion();

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
      descripcion: Descripcion(
        coordenadas: descripcion?.coordenadas ?? '',
        zona: descripcion?.zona ?? '',
        actividad: descripcion?.actividad ?? '',
        equipos: descripcion?.equipos ?? '',
        trabajadores: descripcion?.trabajadores ?? '',
        condicionesLaborales: descripcion?.condicionesLaborales ?? '',
      ),
      evaluacion: const Evaluacion(idCondicionProspecto: 0, anotacion: ''),
      estimacion: const Estimacion(
        capacidadDiaria: 0,
        diasOperacion: 0,
        produccionEstimada: 0,
      ),
      fotos: fotos
          .map(
            (e) => Foto(
              imagen: e.path,
              titulo: e.titulo,
              descripcion: e.descripcion,
              fecha: e.fecha,
              latitud: e.latitud,
              longitud: e.longitud,
            ),
          )
          .toList(),
    );

    await _completarFlujo(comando);

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

