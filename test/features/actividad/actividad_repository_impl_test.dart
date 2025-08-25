import 'package:flutter_test/flutter_test.dart';

import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/fuentes_datos/tipo_actividad_local_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/fuentes_datos/tipo_actividad_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/datos/repositorios/actividad_repository_impl.dart';
import 'package:veta_dorada_vinculacion_mobile/features/actividad/dominio/entidades/tipo_actividad.dart';

class _FakeRemote implements TipoActividadRemoteDataSource {
  _FakeRemote(this.respuesta);

  final RespuestaBase<List<TipoActividad>> respuesta;

  @override
  Future<RespuestaBase<List<TipoActividad>>> obtenerTiposActividad() async {
    return respuesta;
  }
}

class _FakeLocal implements TipoActividadLocalDataSource {
  List<TipoActividad> almacenados = [];

  @override
  Future<List<TipoActividad>> obtenerTiposActividad() async {
    return almacenados;
  }

  @override
  Future<void> reemplazarTiposActividad(List<TipoActividad> tipos) async {
    almacenados = List.from(tipos);
  }
}

void main() {
  group('ActividadRepositoryImpl', () {
    test('sincronizarTiposActividad guarda los datos obtenidos', () async {
      final remoto = _FakeRemote(RespuestaBase(
        codigoRespuesta: RespuestaBase.RESPUESTA_CORRECTA,
        respuesta: [
          TipoActividad(
            id: 1,
            nombre: 'Exploración',
            subTipos: const [SubTipoActividad(id: 10, nombre: 'Sub1')],
          )
        ],
      ));
      final local = _FakeLocal();
      final repo = ActividadRepositoryImpl(remoto, local);

      await repo.sincronizarTiposActividad();

      expect(local.almacenados.length, 1);
      expect(local.almacenados.first.nombre, 'Exploración');
      expect(local.almacenados.first.subTipos.first.nombre, 'Sub1');
    });

    test('sincronizarTiposActividad mantiene datos cuando hay error', () async {
      final remoto = _FakeRemote(RespuestaBase(
        codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
        mensajeError: 'fallo',
      ));
      final local = _FakeLocal();
      local.almacenados = [
        TipoActividad(
          id: 1,
          nombre: 'A',
          subTipos: const [SubTipoActividad(id: 11, nombre: 'A1')],
        )
      ];
      final repo = ActividadRepositoryImpl(remoto, local);

      await repo.sincronizarTiposActividad();

      expect(local.almacenados, isNotEmpty);
      expect(local.almacenados.first.nombre, 'A');
      expect(local.almacenados.first.subTipos.first.nombre, 'A1');
    });

    test('obtenerTiposActividad retorna datos remotos y sincroniza locales', () async {
      final remoto = _FakeRemote(RespuestaBase(
        codigoRespuesta: RespuestaBase.RESPUESTA_CORRECTA,
        respuesta: [
          TipoActividad(
            id: 1,
            nombre: 'Exploración',
            subTipos: const [SubTipoActividad(id: 10, nombre: 'Sub1')],
          )
        ],
      ));
      final local = _FakeLocal();
      final repo = ActividadRepositoryImpl(remoto, local);

      final result = await repo.obtenerTiposActividad();

      expect(result.advertencia, isNull);
      expect(result.tipos.length, 1);
      expect(local.almacenados.length, 1);
      expect(local.almacenados.first.subTipos.first.nombre, 'Sub1');
    });

    test('obtenerTiposActividad retorna locales cuando remoto falla', () async {
      final remoto = _FakeRemote(RespuestaBase(
        codigoRespuesta: RespuestaBase.RESPUESTA_ERROR,
        mensajeError: 'error remoto',
      ));
      final local = _FakeLocal();
      local.almacenados = [
        TipoActividad(
          id: 2,
          nombre: 'Beneficio',
          subTipos: const [SubTipoActividad(id: 20, nombre: 'SubB')],
        )
      ];
      final repo = ActividadRepositoryImpl(remoto, local);

      final result = await repo.obtenerTiposActividad();

      expect(result.advertencia, 'error remoto');
      expect(result.tipos.first.nombre, 'Beneficio');
      expect(result.tipos.first.subTipos.first.nombre, 'SubB');
    });
  });
}

