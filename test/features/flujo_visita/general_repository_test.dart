import 'package:flutter_test/flutter_test.dart';

import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/datos/fuentes_datos/general_local_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/datos/fuentes_datos/general_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/datos/repositorios/general_repository.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/condicion_prospecto.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/inicio_proceso_formalizacion.dart';
import 'package:veta_dorada_vinculacion_mobile/features/flujo_visita/dominio/entidades/tipo_proveedor.dart';

class _FakeRemote implements GeneralRemoteDataSource {
  _FakeRemote({
    RespuestaBase<List<TipoProveedor>>? tipos,
    RespuestaBase<List<InicioProcesoFormalizacion>>? inicios,
    RespuestaBase<List<CondicionProspecto>>? condiciones,
  })  : tiposRespuesta = tipos ??
            RespuestaBase(
                codigoRespuesta: RespuestaBase.RESPUESTA_CORRECTA,
                respuesta: const []),
        iniciosRespuesta = inicios ??
            RespuestaBase(
                codigoRespuesta: RespuestaBase.RESPUESTA_CORRECTA,
                respuesta: const []),
        condicionesRespuesta = condiciones ??
            RespuestaBase(
                codigoRespuesta: RespuestaBase.RESPUESTA_CORRECTA,
                respuesta: const []);

  final RespuestaBase<List<TipoProveedor>> tiposRespuesta;
  final RespuestaBase<List<InicioProcesoFormalizacion>> iniciosRespuesta;
  final RespuestaBase<List<CondicionProspecto>> condicionesRespuesta;

  @override
  Future<RespuestaBase<List<TipoProveedor>>> obtenerTiposProveedor() async {
    return tiposRespuesta;
  }

  @override
  Future<RespuestaBase<List<InicioProcesoFormalizacion>>>
      obtenerIniciosProcesoFormalizacion() async {
    return iniciosRespuesta;
  }

  @override
  Future<RespuestaBase<List<CondicionProspecto>>>
      obtenerCondicionesProspectoVerificacion() async {
    return condicionesRespuesta;
  }
}

class _FakeLocal implements GeneralLocalDataSource {
  _FakeLocal({
    List<TipoProveedor> tipos = const [],
    List<InicioProcesoFormalizacion> inicios = const [],
    List<CondicionProspecto> condiciones = const [],
  })  : tiposAlmacenados = List.from(tipos),
        iniciosAlmacenados = List.from(inicios),
        condicionesAlmacenadas = List.from(condiciones);

  List<TipoProveedor> tiposAlmacenados;
  List<InicioProcesoFormalizacion> iniciosAlmacenados;
  List<CondicionProspecto> condicionesAlmacenadas;

  @override
  Future<List<TipoProveedor>> obtenerTiposProveedor() async {
    return tiposAlmacenados;
  }

  @override
  Future<void> reemplazarTiposProveedor(List<TipoProveedor> tipos) async {
    tiposAlmacenados = List.from(tipos);
  }

  @override
  Future<List<InicioProcesoFormalizacion>> obtenerIniciosFormalizacion() async {
    return iniciosAlmacenados;
  }

  @override
  Future<void> reemplazarIniciosFormalizacion(
      List<InicioProcesoFormalizacion> inicios) async {
    iniciosAlmacenados = List.from(inicios);
  }

  @override
  Future<List<CondicionProspecto>> obtenerCondicionesProspecto() async {
    return condicionesAlmacenadas;
  }

  @override
  Future<void> reemplazarCondicionesProspecto(
      List<CondicionProspecto> condiciones) async {
    condicionesAlmacenadas = List.from(condiciones);
  }
}

void main() {
  group('GeneralRepository', () {
    test('obtenerCondicionesProspecto retorna datos y sincroniza locales',
        () async {
      final remoto = _FakeRemote(
        condiciones: RespuestaBase(
          codigoRespuesta: RespuestaBase.RESPUESTA_CORRECTA,
          respuesta: [
            const CondicionProspecto(id: '1', descripcion: 'Activo'),
          ],
        ),
      );
      final local = _FakeLocal();
      final repo = GeneralRepository(remoto, local);

      final result = await repo.obtenerCondicionesProspecto();

      expect(result.advertencia, isNull);
      expect(result.condiciones.length, 1);
      expect(local.condicionesAlmacenadas.length, 1);
    });

    test(
        'sincronizarDatosGenerales limpia datos locales cuando la API falla',
        () async {
      final remoto = _FakeRemote(
        tipos: RespuestaBase(
          codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
          mensajeError: 'fallo',
        ),
        inicios: RespuestaBase(
          codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
          mensajeError: 'fallo',
        ),
        condiciones: RespuestaBase(
          codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
          mensajeError: 'fallo',
        ),
      );
      final local = _FakeLocal(
        tipos: [const TipoProveedor(id: '1', descripcion: 'Tipo')],
        inicios: [const InicioProcesoFormalizacion(id: '1', descripcion: 'Ini')],
        condiciones: [const CondicionProspecto(id: '1', descripcion: 'Cond')],
      );
      final repo = GeneralRepository(remoto, local);

      await repo.sincronizarDatosGenerales();

      expect(local.tiposAlmacenados, isEmpty);
      expect(local.iniciosAlmacenados, isEmpty);
      expect(local.condicionesAlmacenadas, isEmpty);
    });
  });
}
