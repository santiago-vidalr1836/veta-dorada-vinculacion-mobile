import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';
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
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _espesorController = TextEditingController();
  final TextEditingController _disparosController = TextEditingController();
  final TextEditingController _diasController = TextEditingController();
  final TextEditingController _rocaCajaController = TextEditingController();
  late RealizarVerificacionDto _dto;

  @override
  void initState() {
    super.initState();
    _dto = widget.dto;
  }

  @override
  void dispose() {
    _longitudController.dispose();
    _alturaController.dispose();
    _espesorController.dispose();
    _disparosController.dispose();
    _diasController.dispose();
    _rocaCajaController.dispose();
    super.dispose();
  }

  Future<void> _calcular() async {
    if (!_formKey.currentState!.validate()) return;
    final longitud = double.tryParse(_longitudController.text) ?? 0;
    final altura = double.tryParse(_alturaController.text) ?? 0;
    final espesor = double.tryParse(_espesorController.text) ?? 0;
    final disparos = double.tryParse(_disparosController.text) ?? 0;
    final dias = double.tryParse(_diasController.text) ?? 0;
    final rocaCaja = double.tryParse(_rocaCajaController.text) ?? 0;
    final pd = longitud * altura * espesor * 3.2 * disparos;
    final pme = pd * dias;
    final produccionMensual = pme + (pme * rocaCaja / 100);
    final estimacion = Estimacion(
      longitudAvance: longitud,
      alturaFrente: altura,
      espesorVeta: espesor,
      numeroDisparosDia: disparos,
      diasTrabajados: dias,
      porcentajeRocaCaja: rocaCaja,
      produccionDiariaEstimada: pd,
      produccionMensualEstimada: pme,
      produccionMensual: produccionMensual,
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
        extra: estimacion);
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(
              width: 378,
              child: Text(
                'Estimación de Producción',
                style: TextStyle(
                  color: Color(0xFF1D1B20),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 1.27,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _longitudController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Longitud de avance (m)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Ingrese la longitud'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alturaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Altura del frente (m)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Ingrese la altura'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _espesorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Espesor de la veta (m)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Ingrese el espesor'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _disparosController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de disparos por día',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Ingrese los disparos'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _diasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Días trabajados',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Ingrese los días' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rocaCajaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Porcentaje de roca caja (%)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Ingrese el porcentaje'
                  : null,
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

