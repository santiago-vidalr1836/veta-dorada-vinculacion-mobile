import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/visita.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';
import '../../datos/repositorios/general_repository.dart';
import '../../../actividad/dominio/entidades/actividad.dart';
import '../../dominio/entidades/descripcion.dart';
import '../../dominio/entidades/evaluacion.dart';
import '../../dominio/entidades/estimacion.dart';
import '../../dominio/entidades/foto.dart';
import '../../dominio/entidades/inicio_proceso_formalizacion.dart';
import '../../dominio/entidades/proveedor_snapshot.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/entidades/tipo_proveedor.dart';
import '../../dominio/repositorios/verificacion_repository.dart';
import '../../dominio/calcular_avance.dart';

/// Página para registrar los datos del proveedor de mineral.
///
/// Muestra un formulario para registrar la información del proveedor.
class DatosProveedorMineralPagina extends StatefulWidget {
  const DatosProveedorMineralPagina({
    super.key,
    required this.visita,
    required this.repository,
    required this.verificacionRepository,
  });

  final Visita visita;
  final GeneralRepository repository;
  final VerificacionRepository verificacionRepository;

  @override
  State<DatosProveedorMineralPagina> createState() =>
      _DatosProveedorMineralPaginaState();
}

class _DatosProveedorMineralPaginaState
    extends State<DatosProveedorMineralPagina> {
  static const String TIPO_PERSONA_NATURAL = 'TIPO_PERSONA_NATURAL';
  static const String TIPO_PERSONA_JURIDICA = 'TIPO_PERSONA_JURIDICA';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _razonSocialController = TextEditingController();
  final TextEditingController _representanteController = TextEditingController();

  List<TipoProveedor> _tiposPersona = [];
  TipoProveedor? _tipoPersona;
  List<InicioProcesoFormalizacion> _iniciosFormalizacion = [];
  InicioProcesoFormalizacion? _inicioFormalizacion;

  static const int _totalPasos = totalPasosVerificacion;
  double _avance = 0;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    final dto =
        await widget.verificacionRepository.obtenerVerificacion(widget.visita.id);

    if (dto != null) {
      final proveedor = dto.proveedorSnapshot;
      _nombreController.text = proveedor?.nombre??'';
      _rucController.text = proveedor?.ruc ?? '';
      _razonSocialController.text = proveedor?.razonSocial ?? '';
      _representanteController.text = proveedor?.representanteLegal ?? '';
    } else {
      final proveedor = widget.visita.proveedor;
      _nombreController.text = proveedor.nombreCompleto ?? '';
      _rucController.text = proveedor.ruc;
      _razonSocialController.text = proveedor.razonSocial ?? '';
      _representanteController.text = proveedor.representanteNombre ?? '';
    }

    await _cargarCatalogos(dto);
    _avance = dto != null ? calcularAvance(dto) : 0;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _cargarCatalogos(RealizarVerificacionDto? dto) async {
    final tipos = await widget.repository.obtenerTiposProveedor();
    final inicios = await widget.repository.obtenerIniciosFormalizacion();
    setState(() {
      _tiposPersona = tipos.tipos;
      _iniciosFormalizacion = inicios.inicios;
      final codigoTipo =
          dto?.proveedorSnapshot?.tipoPersona ?? widget.visita.proveedor.tipo.codigo;
      for (final tipo in _tiposPersona) {
        if (tipo.codigo == codigoTipo) {
          _tipoPersona = tipo;
          break;
        }
      }
      if (_inicioFormalizacion != null) {
        for (final inicio in _iniciosFormalizacion) {
          if (inicio.codigo == _inicioFormalizacion!.codigo) {
            _inicioFormalizacion = inicio;
            break;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rucController.dispose();
    _razonSocialController.dispose();
    _representanteController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    if (_tipoPersona == null || _inicioFormalizacion == null) {
      return false;
    }
    if (_tipoPersona!.codigo == TIPO_PERSONA_NATURAL) {
      return _nombreController.text.isNotEmpty;
    }
    if (_tipoPersona!.codigo == TIPO_PERSONA_JURIDICA) {
      return _rucController.text.isNotEmpty &&
          _razonSocialController.text.isNotEmpty &&
          _representanteController.text.isNotEmpty;
    }
    return false;
  }

  Future<void> _siguiente() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final proveedor = ProveedorSnapshot(
      tipoPersona: _tipoPersona!.codigo,
      nombre: _nombreController.text,
      ruc: _rucController.text.isEmpty ? null : _rucController.text,
      razonSocial:
          _razonSocialController.text.isEmpty ? null : _razonSocialController.text,
      representanteLegal: _representanteController.text.isEmpty
          ? null
          : _representanteController.text,
      inicioFormalizacion: _inicioFormalizacion?.codigo,
    );
    var dto =
        await widget.verificacionRepository.obtenerVerificacion(widget.visita.id);
    if (dto == null) {
      dto = RealizarVerificacionDto(
        idVerificacion: 0,
        idVisita: widget.visita.id,
        idUsuario: widget.visita.geologo.id,
        fechaInicioMovil: DateTime.now(),
        fechaFinMovil: DateTime.now(),
        proveedorSnapshot: proveedor,
        actividades: const <Actividad>[],
        descripcion: const Descripcion(
          coordenadas: '',
          zona: '',
          actividad: '',
          equipos: '',
          trabajadores: '',
          condicionesLaborales: '',
        ),
        evaluacion: const Evaluacion(idCondicionProspecto: '', anotacion: ''),
        estimacion: const Estimacion(
          longitudAvance: 0,
          alturaFrente: 0,
          espesorVeta: 0,
          numeroDisparosDia: 0,
          diasTrabajados: 0,
          porcentajeRocaCaja: 0,
          produccionDiariaEstimada: 0,
          produccionMensualEstimada: 0,
          produccionMensual: 0,
        ),
        fotos: const <Foto>[],
        idempotencyKey: '',
      );
    } else {
      dto = RealizarVerificacionDto(
        idVerificacion: dto.idVerificacion,
        idVisita: dto.idVisita,
        idUsuario: dto.idUsuario,
        fechaInicioMovil: dto.fechaInicioMovil,
        fechaFinMovil: dto.fechaFinMovil,
        proveedorSnapshot: proveedor,
        actividades: dto.actividades,
        descripcion: dto.descripcion,
        evaluacion: dto.evaluacion,
        estimacion: dto.estimacion,
        fotos: dto.fotos,
        idempotencyKey: dto.idempotencyKey,
      );
    }
    await widget.verificacionRepository.guardarVerificacion(dto);
    _avance = calcularAvance(dto);
    if (!mounted) return;
    setState(() {});
    context.push('/flujo-visita/resumen');
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return ProtectedScaffold(
      usuario: auth.usuario!,
      token: auth.token!,
      onNavigate: (ruta) => context.go(ruta),
      body: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.visita.id}'.padLeft(4, '0'),
                    style: TextStyle(
                      color: const Color(0xFF1D1B20) /* Schemes-On-Surface */,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.50,
                    ),
                  ),
                  Text(
                      '${(_avance * _totalPasos).round()} de ''$_totalPasos',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              LinearProgressIndicator(value: _avance),
              const SizedBox(height: 32),
              const SizedBox(
                width: 378,
                child: Text(
                  'Datos del proveedor de mineral',
                  style: TextStyle(
                    color: Color(0xFF1D1B20),
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    height: 1.27,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              DropdownButtonFormField<TipoProveedor>(
                value: _tipoPersona,
                decoration: const InputDecoration(labelText: 'Tipo de persona',border: OutlineInputBorder()),
                items: _tiposPersona
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.nombre),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoPersona = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione el tipo de persona' : null,
              ),
              const SizedBox(height: 16),
              if (_tipoPersona?.codigo == TIPO_PERSONA_NATURAL) ...[
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre',border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}),
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Ingrese el nombre'
                          : null,
                ),
                const SizedBox(height: 16),
              ],
              if (_tipoPersona?.codigo == TIPO_PERSONA_JURIDICA) ...[
                TextFormField(
                  controller: _rucController,
                  decoration: const InputDecoration(labelText: 'RUC',border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}),
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Ingrese el RUC'
                          : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _razonSocialController,
                  decoration:
                      const InputDecoration(labelText: 'Razón Social',border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}),
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Ingrese la razón social'
                          : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _representanteController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre completo del representante legal',border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}),
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Ingrese el nombre del representante'
                          : null,
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<InicioProcesoFormalizacion>(
                value: _inicioFormalizacion,
                decoration: const InputDecoration(
                    labelText: 'Inicio de Proceso de Formalización',border: OutlineInputBorder()),
                items: _iniciosFormalizacion
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.nombre),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _inicioFormalizacion = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una opción' : null,
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                  onPressed: _isFormValid ? _siguiente : null,
                  child: const Text('Siguiente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

