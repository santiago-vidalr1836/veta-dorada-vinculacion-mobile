import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../actividad/dominio/entidades/actividad.dart';
import '../../datos/repositorios/general_repository.dart';
import '../../dominio/entidades/condicion_prospecto.dart';
import '../../dominio/entidades/evaluacion.dart';
import '../../dominio/repositorios/flow_repository.dart';

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
    required this.flowRepository,
  });

  /// Actividad relacionada a la evaluación.
  final Actividad actividad;

  /// Repositorio para obtener las condiciones del prospecto.
  final GeneralRepository repository;

  /// Indica si la visita requiere medición de capacidad.
  final bool flagMedicionCapacidad;

  /// Repositorio para almacenar la evaluación.
  final FlowRepository flowRepository;

  @override
  State<EvaluacionLaborPagina> createState() => _EvaluacionLaborPaginaState();
}

class _EvaluacionLaborPaginaState extends State<EvaluacionLaborPagina> {
  final _formKey = GlobalKey<FormState>();

  List<CondicionProspecto> _condiciones = [];
  CondicionProspecto? _condicionSeleccionada;

  final TextEditingController _anotacionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarCondiciones();
  }

  Future<void> _cargarCondiciones() async {
    final resultado = await widget.repository.obtenerCondicionesProspecto();
    setState(() {
      _condiciones = resultado.condiciones;
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
    await widget.flowRepository.guardarEvaluacion(evaluacion);
    if (!mounted) return;
    context.push('/flujo-visita/estimacion-produccion',
        extra: widget.flagMedicionCapacidad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluación de la labor')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<CondicionProspecto>(
                decoration: const InputDecoration(
                  labelText: 'Condición del prospecto',
                ),
                value: _condicionSeleccionada,
                items: _condiciones
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.descripcion),
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

