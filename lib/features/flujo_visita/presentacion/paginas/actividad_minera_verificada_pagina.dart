import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';
import '../../../actividad/datos/repositorios/actividad_repository_impl.dart';
import '../../../actividad/dominio/entidades/actividad.dart';
import '../../../actividad/dominio/entidades/tipo_actividad.dart';
import '../../../actividad/dominio/enums/origen.dart';
import '../../dominio/entidades/descripcion.dart';
import '../../dominio/entidades/evaluacion.dart';
import '../../dominio/entidades/estimacion.dart';
import '../../dominio/entidades/foto.dart';
import '../../dominio/entidades/proveedor_snapshot.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/repositorios/verificacion_repository.dart';
import '../../dominio/calcular_avance.dart';

/// Página para registrar una actividad minera verificada por la autoridad.
///
/// Carga los tipos de actividad desde el [ActividadRepositoryImpl] y permite
/// seleccionar un tipo y sub tipo además de registrar información adicional
/// como coordenadas y ubicación política.
class ActividadMineraVerificadaPagina extends StatefulWidget {
  const ActividadMineraVerificadaPagina({
    super.key,
    required this.repository,
    required this.verificacionRepository,
    required this.flagMedicionCapacidad,
    required this.flagEstimacionProduccion,
    required this.idVisita,
  });

  /// Repositorio usado para obtener los tipos de actividad.
  final ActividadRepositoryImpl repository;

  /// Repositorio para persistir la verificación.
  final VerificacionRepository verificacionRepository;

  /// Indica si la visita requiere medición de capacidad.
  final bool flagMedicionCapacidad;

  /// Indica si la visita requiere estimación de producción.
  final bool flagEstimacionProduccion;

  /// Identificador de la visita asociada a la verificación.
  final int idVisita;

  @override
  State<ActividadMineraVerificadaPagina> createState() =>
      _ActividadMineraVerificadaPaginaState();
}

class _ActividadMineraVerificadaPaginaState
    extends State<ActividadMineraVerificadaPagina> {
  final _formKey = GlobalKey<FormState>();

  List<TipoActividad> _tipos = [];
  TipoActividad? _tipoSeleccionado;
  SubTipoActividad? _subTipoSeleccionado;
  List<SubTipoActividad> _subTiposDisponibles = [];
  String _labelSubTipo = 'Sub Tipo';

  final TextEditingController _sistemaController = TextEditingController();
  final TextEditingController _zonaController = TextEditingController();
  final TextEditingController _comp01EsteController = TextEditingController();
  final TextEditingController _comp01NorteController = TextEditingController();
  final TextEditingController _comp02EsteController = TextEditingController();
  final TextEditingController _comp02NorteController = TextEditingController();
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _distritoController = TextEditingController();
  final TextEditingController _derechoMineroController =
      TextEditingController();

  static const int _totalPasos = totalPasosVerificacion;
  double _avance = 0;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  @override
  void dispose() {
    _sistemaController.dispose();
    _zonaController.dispose();
    _comp01EsteController.dispose();
    _comp01NorteController.dispose();
    _comp02EsteController.dispose();
    _comp02NorteController.dispose();
    _departamentoController.dispose();
    _provinciaController.dispose();
    _distritoController.dispose();
    _derechoMineroController.dispose();
    super.dispose();
  }

  Future<void> _inicializar() async {
    final dto = await widget.verificacionRepository
        .obtenerVerificacion(widget.idVisita);
    final resultado = await widget.repository.obtenerTiposActividad();
    _tipos = resultado.tipos;

    Actividad? actividad;
    if (dto != null) {
      try {
        actividad =
            dto.actividades?.firstWhere((a) => a.origen == Origen.verificada);
      } catch (_) {
        actividad = null;
      }
    }

    if (actividad != null) {
      for (final tipo in _tipos) {
        if (tipo.id == actividad.idTipoActividad) {
          _tipoSeleccionado = tipo;
          _labelSubTipo = 'Tipo de ${tipo.nombre}';
          _subTiposDisponibles = tipo.subTipos;
          if (actividad.idSubTipoActividad > 0) {
            try {
              _subTipoSeleccionado = tipo.subTipos.firstWhere(
                (st) => st.id == actividad.idSubTipoActividad,
              );
            } catch (_) {
              _subTipoSeleccionado = null;
            }
          }
          break;
        }
      }
      _sistemaController.text = actividad.sistemaUTM?.toString() ?? '';
      _zonaController.text = actividad.zonaUTM?.toString() ?? '';
      _comp01EsteController.text = actividad.utmEste.toString();
      _comp01NorteController.text = actividad.utmNorte.toString();
      _derechoMineroController.text = actividad.derechoMinero ?? '';
    }

    _avance = dto != null ? calcularAvance(dto) : 0;

    if (mounted) {
      setState(() {});
    }
  }

  void _onTipoChanged(TipoActividad? tipo) {
    setState(() {
      _tipoSeleccionado = tipo;
      _subTipoSeleccionado = null;
      _subTiposDisponibles = tipo?.subTipos ?? [];
      if (tipo != null) {
        _labelSubTipo = 'Tipo de ${tipo.nombre}';
      } else {
        _labelSubTipo = 'Sub Tipo';
      }
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate() ||
        _tipoSeleccionado == null ||
        _subTipoSeleccionado == null) {
      return;
    }
    final actividad = Actividad(
      id: '',
      origen: Origen.verificada,
      idTipoActividad: _tipoSeleccionado!.id,
      idSubTipoActividad: _subTipoSeleccionado!.id,
      sistemaUTM: int.tryParse(_sistemaController.text) ?? 0,
      utmEste: double.tryParse(_comp01EsteController.text) ?? 0,
      utmNorte: double.tryParse(_comp01NorteController.text) ?? 0,
      zonaUTM: int.tryParse(_zonaController.text),
      descripcion: null,
      derechoMinero: _derechoMineroController.text,
    );

    var dto = await widget.verificacionRepository
        .obtenerVerificacion(widget.idVisita);
    dto ??= RealizarVerificacionDto(
      idVerificacion: 0,
      idVisita: widget.idVisita,
      idUsuario: 0,
      proveedorSnapshot: const ProveedorSnapshot(
        tipoPersona: '',
        nombre: '',
        inicioFormalizacion: '',
      ),
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
    final actividades =
        List<Actividad>.from(dto.actividades ?? <Actividad>[]);
    final index = actividades.indexWhere((a) => a.origen == Origen.verificada);
    if (index >= 0) {
      actividades[index] = actividad;
    } else {
      actividades.add(actividad);
    }
    dto = dto.copyWith(actividades: actividades);
    await widget.verificacionRepository.guardarVerificacion(dto);
    _avance = calcularAvance(dto);
    final actividadGuardada =
        dto.actividades?.firstWhere((a) => a.origen == Origen.verificada);
    if (!mounted) return;
    context.push('/flujo-visita/descripcion-actividad-verificada', extra: {
      'actividad': actividadGuardada,
      'flagMedicionCapacidad': widget.flagMedicionCapacidad,
      'flagEstimacionProduccion': widget.flagEstimacionProduccion,
      'dto': dto,
    });
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                width: 378,
                child: Text(
                  'Actividad Minera Verificada',
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
              DropdownButtonFormField<TipoActividad>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de actividad',
                ),
                value: _tipoSeleccionado,
                items: _tipos
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.nombre),
                        ))
                    .toList(),
                onChanged: _onTipoChanged,
                validator: (value) =>
                    value == null ? 'Seleccione el tipo de actividad' : null,
              ),
              const SizedBox(height: 16),
              if (_subTiposDisponibles.isNotEmpty)
                DropdownButtonFormField<SubTipoActividad>(
                  decoration: InputDecoration(labelText: _labelSubTipo),
                  value: _subTipoSeleccionado,
                  items: _subTiposDisponibles
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.nombre),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _subTipoSeleccionado = value),
                  validator: (value) =>
                      value == null ? 'Seleccione una opción' : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sistemaController,
                decoration: const InputDecoration(
                  labelText: 'Sistema UTM',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zonaController,
                decoration: const InputDecoration(
                  labelText: 'Zona',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Coordenadas Componente 01'),
              TextFormField(
                controller: _comp01EsteController,
                decoration: const InputDecoration(
                  labelText: 'Este',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _comp01NorteController,
                decoration: const InputDecoration(
                  labelText: 'Norte',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Coordenadas Componente 02'),
              TextFormField(
                controller: _comp02EsteController,
                decoration: const InputDecoration(
                  labelText: 'Este',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _comp02NorteController,
                decoration: const InputDecoration(
                  labelText: 'Norte',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departamentoController,
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _provinciaController,
                decoration: const InputDecoration(
                  labelText: 'Provincia',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _distritoController,
                decoration: const InputDecoration(
                  labelText: 'Distrito',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _derechoMineroController,
                decoration: const InputDecoration(
                  labelText: 'Derecho minero',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardar,
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

