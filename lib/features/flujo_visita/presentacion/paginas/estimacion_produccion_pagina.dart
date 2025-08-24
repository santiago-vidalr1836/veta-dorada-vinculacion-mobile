import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../dominio/entidades/estimacion.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/repositorios/verificacion_repository.dart';

/// Página para estimar la producción de la operación.
///
/// Recibe un [flagMedicionCapacidad] que indica si la medición de
/// capacidad está habilitada y muestra un indicador visual en consecuencia.
class EstimacionProduccionPagina extends StatefulWidget {
  const EstimacionProduccionPagina({
    super.key,
    required this.flagMedicionCapacidad,
    required this.verificacionRepository,
    required this.dto,
  });

  /// Indica si se debe mostrar el indicador de capacidad operativa.
  final bool flagMedicionCapacidad;
  final VerificacionRepository verificacionRepository;
  final RealizarVerificacionDto dto;

  @override
  State<EstimacionProduccionPagina> createState() =>
      _EstimacionProduccionPaginaState();
}

class _EstimacionProduccionPaginaState
    extends State<EstimacionProduccionPagina> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capacidadController = TextEditingController();
  final TextEditingController _diasController = TextEditingController();
  late RealizarVerificacionDto _dto;

  @override
  void initState() {
    super.initState();
    _dto = widget.dto;
  }

  @override
  void dispose() {
    _capacidadController.dispose();
    _diasController.dispose();
    super.dispose();
  }

  Future<void> _calcular() async {
    if (!_formKey.currentState!.validate()) return;
    final capacidad = double.tryParse(_capacidadController.text) ?? 0;
    final dias = double.tryParse(_diasController.text) ?? 0;
    final estimacionValor = capacidad * dias;
    final estimacion = Estimacion(
      capacidadDiaria: capacidad,
      diasOperacion: dias,
      produccionEstimada: estimacionValor,
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
      evaluacion: _dto.evaluacion,
      estimacion: estimacion,
      fotos: _dto.fotos,
      idempotencyKey: _dto.idempotencyKey,
    );
    await widget.verificacionRepository.guardarVerificacion(dtoActualizado);
    if (!mounted) return;
    context.push('/flujo-visita/estimacion-produccion/resultado',
        extra: estimacionValor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estimación de Producción')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _capacidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Capacidad diaria (t)',
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Ingrese la capacidad' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _diasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Días de operación',
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Ingrese los días' : null,
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: widget.flagMedicionCapacidad,
              child: const Text('Capacidad operativa habilitada'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text('Estimar'),
            ),
          ],
        ),
      ),
    );
  }
}

