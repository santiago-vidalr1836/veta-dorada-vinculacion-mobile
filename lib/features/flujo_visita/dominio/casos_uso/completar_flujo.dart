import 'dart:io';

import '../../datos/fuentes_datos/documento_remote_data_source.dart';
import '../entidades/completar_visita_comando.dart';
import '../entidades/descripcion.dart';
import '../entidades/evaluacion.dart';
import '../entidades/estimacion.dart';
import '../entidades/foto.dart';
import '../entidades/registro_fotografico.dart';
import '../repositorios/flow_repository.dart';

/// Caso de uso encargado de completar el flujo de visita.
///
/// Sube las fotografías al servidor, reemplaza sus rutas locales por las
/// URL retornadas y finalmente envía el comando completo al repositorio.
class CompletarFlujo {
  CompletarFlujo(this._documentoRemote, this._repository);

  final DocumentoRemoteDataSource _documentoRemote;
  final FlowRepository _repository;

  Future<void> call(CompletarVisitaComando base) async {
    final descripcionLocal =
        await _repository.obtenerDescripcionActividadVerificada();
    final evaluacionLocal = await _repository.obtenerEvaluacion();
    final estimacionLocal = await _repository.obtenerEstimacion();
    final registros = await _repository.obtenerFotosVerificacion();

    final List<Foto> fotosActualizadas = [];
    for (final RegistroFotografico registro in registros) {
      final file = File(registro.path);
      final url = await _documentoRemote.subirDocumento(file);
      fotosActualizadas.add(
        Foto(
          imagen: url,
          titulo: registro.titulo,
          descripcion: registro.descripcion,
          fecha: registro.fecha,
          latitud: registro.latitud,
          longitud: registro.longitud,
        ),
      );
    }

    final comando = CompletarVisitaComando(
      idVisita: base.idVisita,
      proveedor: base.proveedor,
      actividad: base.actividad,
      descripcion: Descripcion(
        coordenadas: descripcionLocal?.coordenadas ?? '',
        zona: descripcionLocal?.zona ?? '',
        actividad: descripcionLocal?.actividad ?? '',
        equipos: descripcionLocal?.equipos ?? '',
        trabajadores: descripcionLocal?.trabajadores ?? '',
        condicionesLaborales:
            descripcionLocal?.condicionesLaborales ?? '',
      ),
      evaluacion: evaluacionLocal ??
          const Evaluacion(idCondicionProspecto: '0', anotacion: ''),
      estimacion: estimacionLocal ??
          const Estimacion(
            capacidadDiaria: 0,
            diasOperacion: 0,
            produccionEstimada: 0,
          ),
      fotos: fotosActualizadas,
    );

    await _repository.completarFlujo(comando);
  }
}

