import 'package:flutter_test/flutter_test.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/respuesta_base.dart';
import 'package:veta_dorada_vinculacion_mobile/core/servicios/servicio_bd_local.dart';
import 'package:veta_dorada_vinculacion_mobile/core/red/cliente_http.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/oficina.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/perfil.dart';
import 'package:veta_dorada_vinculacion_mobile/features/perfil/datos/modelos/usuario.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/datos/fuentes_datos/visits_local_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/datos/fuentes_datos/visits_remote_data_source.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/datos/modelos/visita_model.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/datos/repositorios/visits_repository_impl.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/derecho_minero.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/estado_visita.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/general.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/proveedor.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/tipo_visita.dart';

class _FakeClienteHttp extends ClienteHttp {
  _FakeClienteHttp() : super(token: '');
}

class _FakeRemote extends VisitsRemoteDataSource {
  _FakeRemote() : super(_FakeClienteHttp());
  @override
  Future<RespuestaBase<List<VisitaModel>>> obtenerVisitas(int id) async {
    return RespuestaBase.respuestaCorrecta([
      _buildVisita(1, General.ESTADO_VISITA_PROGRAMADA),
      _buildVisita(2, General.ESTADO_VISITA_REALIZADA),
      _buildVisita(3, General.ESTADO_VISITA_EN_PROCESO),
    ]);
  }
}

class _FakeLocal extends VisitsLocalDataSource {
  _FakeLocal() : super(ServicioBdLocal());
  @override
  Future<void> insertVisits(List<VisitaModel> visits) async {}
  @override
  Future<Map<String, List<VisitaModel>>> getVisitsGroupedByState() async => {};
}

VisitaModel _buildVisita(int id, String estadoCodigo) {
  final generalEstado = General(codigo: estadoCodigo, nombre: '', descripcion: null);
  final general = General(codigo: '', nombre: '', descripcion: null);
  final proveedor = Proveedor(id: 1, tipo: general, ruc: '', estado: general);
  final tipo = TipoVisita(id: 1, codigo: '', nombre: '');
  final derecho = DerechoMinero(id: 1, codigo: '', denominacion: '');
  final usuario = Usuario(id: 1, nombre: '', apellidos: '', correo: '',oficina: Oficina(id: 0, nombre: ''),perfil: Perfil(id: 0, nombre: ''));
  return VisitaModel(
    id: id,
    estado: generalEstado,
    proveedor: proveedor,
    tipoVisita: tipo,
    derechoMinero: derecho,
    fechaProgramada: DateTime(2023),
    geologo: usuario,
    acopiador: usuario,
    flagEstimacionProduccion: false
  );
}

void main() {
  test('agrupa visitas según el estado', () async {
    final repo = VisitsRepositoryImpl(_FakeRemote(), _FakeLocal());
    final resultado = await repo.obtenerVisitasPorGeologo(1);
    expect(resultado.visitas[EstadoVisita.programada]!.length, 1);
    expect(resultado.visitas[EstadoVisita.realizada]!.length, 1);
    expect(resultado.visitas[EstadoVisita.enProceso]!.length, 1);
  });
}
