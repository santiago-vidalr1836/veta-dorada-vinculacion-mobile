import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';
import '../../../actividad/dominio/entidades/actividad.dart';
import '../../datos/repositorios/general_repository.dart';
import '../../dominio/entidades/condicion_prospecto.dart';
import '../../dominio/entidades/evaluacion.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/repositorios/verificacion_repository.dart';

/// Página para evaluar la labor durante la visita.
///
/// Permite seleccionar la condición del prospecto y registrar una anotación
/// adicional antes de continuar con el flujo.
class EvaluacionLaborPagina extends StatefulWidget {
  const EvaluacionLaborPagina({
    super.key,
    required this.actividad,
    required this.repository,
    required this.flagMedicionCapacidad,
    required this.flagEstimacionProduccion,
    required this.verificacionRepository,
    required this.dto,
  });

  /// Actividad relacionada a la evaluación.
  final Actividad actividad;

  /// Repositorio para obtener las condiciones del prospecto.
  final GeneralRepository repository;

  /// Indica si la visita requiere medición de capacidad.
  final bool flagMedicionCapacidad;

  /// Indica si la visita requiere estimación de producción.
  final bool flagEstimacionProduccion;

  /// Repositorio para almacenar la evaluación.
  final VerificacionRepository verificacionRepository;

  /// Datos actuales de la verificación.
  final RealizarVerificacionDto dto;

  @override
  State<EvaluacionLaborPagina> createState() => _EvaluacionLaborPaginaState();
}

class _EvaluacionLaborPaginaState extends State<EvaluacionLaborPagina> {
  final _formKey = GlobalKey<FormState>();

  List<CondicionProspecto> _condiciones = [];
  CondicionProspecto? _condicionSeleccionada;

  final TextEditingController _anotacionController = TextEditingController();
  late RealizarVerificacionDto _dto;

  @override
  void initState() {
    super.initState();
    _dto = widget.dto;
    _init();
  }

  Future<void> _init() async {
    final previa =
        await widget.verificacionRepository.obtenerVerificacion(widget.dto.idVisita);
    if (previa != null) {
      _dto = previa;
    }
    _anotacionController.text = _dto.evaluacion?.anotacion ?? '';
    await _cargarCondiciones();
  }

  Future<void> _cargarCondiciones() async {
    final condiciones =
        await widget.repository.obtenerCondicionesProspectoVerificacion();
    setState(() {
      _condiciones = condiciones;
      for (final cond in _condiciones) {
        if (cond.codigo == _dto.evaluacion?.idCondicionProspecto) {
          _condicionSeleccionada = cond;
          break;
        }
      }
    });
  }

  @override
  void dispose() {
    _anotacionController.dispose();
    super.dispose();
  }

  bool get _isFormValid => _condicionSeleccionada != null;

  Future<void> _siguiente() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final evaluacion = Evaluacion(
      idCondicionProspecto: _condicionSeleccionada!.codigo,
      anotacion:
          _anotacionController.text.isEmpty ? null : _anotacionController.text,
    );
    final dtoActualizado = RealizarVerificacionDto(
      idVerificacion: _dto.idVerificacion,
      idVisita: _dto.idVisita,
      idUsuario: _dto.idUsuario,
      fechaInicioMovil: _dto.fechaInicioMovil,
      fechaFinMovil: _dto.fechaFinMovil,
      proveedorSnapshot: _dto.proveedorSnapshot,
      actividades: _dto.actividades,
      descripcion: _dto.descripcion,
      evaluacion: evaluacion,
      estimacion: _dto.estimacion,
      fotos: _dto.fotos,
      idempotencyKey: _dto.idempotencyKey,
    );
    await widget.verificacionRepository.guardarVerificacion(dtoActualizado);
    if (!mounted) return;
    context.push('/flujo-visita/firma', extra: {
      'actividad': widget.actividad,
      'flagMedicionCapacidad': widget.flagMedicionCapacidad,
      'flagEstimacionProduccion': widget.flagEstimacionProduccion,
      'dto': dtoActualizado,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 378,
                child: Text(
                  'Evaluación de la labor',
                  style: TextStyle(
                    color: Color(0xFF1D1B20),
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    height: 1.27,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CondicionProspecto>(
                decoration: const InputDecoration(
                  labelText: 'Condición del prospecto',
                ),
                value: _condicionSeleccionada,
                items: _condiciones
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.nombre),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _condicionSeleccionada = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione la condición' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _anotacionController,
                decoration: const InputDecoration(
                  labelText: 'Anotación',
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                minLines: 3,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
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

