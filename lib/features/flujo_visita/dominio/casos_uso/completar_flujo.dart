import 'dart:io';

import '../../datos/fuentes_datos/documento_remote_data_source.dart';
import '../entidades/completar_visita_comando.dart';
import '../entidades/foto.dart';
import '../repositorios/flow_repository.dart';

/// Caso de uso encargado de completar el flujo de visita.
///
/// Sube las fotografías al servidor, reemplaza sus rutas locales por las
/// URL retornadas y finalmente envía el comando completo al repositorio.
class CompletarFlujo {
  CompletarFlujo(this._documentoRemote, this._repository);

  final DocumentoRemoteDataSource _documentoRemote;
  final FlowRepository _repository;

  Future<void> call(CompletarVisitaComando comando) async {
    final List<Foto> fotosActualizadas = [];
    for (final foto in comando.fotos) {
      final file = File(foto.imagen);
      final url = await _documentoRemote.subirDocumento(file);
      fotosActualizadas.add(
        Foto(
          imagen: url,
          titulo: foto.titulo,
          descripcion: foto.descripcion,
          fecha: foto.fecha,
          latitud: foto.latitud,
          longitud: foto.longitud,
        ),
      );
    }

    final actualizado = CompletarVisitaComando(
      idVisita: comando.idVisita,
      proveedor: comando.proveedor,
      actividad: comando.actividad,
      descripcion: comando.descripcion,
      evaluacion: comando.evaluacion,
      estimacion: comando.estimacion,
      fotos: fotosActualizadas,
    );

    await _repository.completarFlujo(actualizado);
  }
}

