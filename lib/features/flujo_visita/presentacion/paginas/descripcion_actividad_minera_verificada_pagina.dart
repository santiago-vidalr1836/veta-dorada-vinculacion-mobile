import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';
import '../../../../core/widgets/bottom_nav_actions.dart';
import '../../../actividad/dominio/entidades/actividad.dart';
import '../../dominio/entidades/descripcion_actividad_verificada.dart';
import '../../dominio/entidades/descripcion.dart';
import '../../dominio/repositorios/verificacion_repository.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/calcular_avance.dart';

/// Página para describir la actividad minera verificada.
///
/// Muestra un formulario con varias secciones de información
/// complementaria respecto a la actividad verificada.
class DescripcionActividadMineraVerificadaPagina extends StatefulWidget {
  const DescripcionActividadMineraVerificadaPagina({
    super.key,
    required this.actividad,
    required this.flagMedicionCapacidad,
    required this.flagEstimacionProduccion,
    required this.verificacionRepository,
    required this.dto,
  });

  final Actividad actividad;
  final bool flagMedicionCapacidad;
  final bool flagEstimacionProduccion;
  final VerificacionRepository verificacionRepository;
  final RealizarVerificacionDto dto;

  @override
  State<DescripcionActividadMineraVerificadaPagina> createState() =>
      _DescripcionActividadMineraVerificadaPaginaState();
}

class _DescripcionActividadMineraVerificadaPaginaState
    extends State<DescripcionActividadMineraVerificadaPagina> {
  final _formKey = GlobalKey<FormState>();

  final _coordenadasController = TextEditingController();
  final _zonaController = TextEditingController();
  final _actividadController = TextEditingController();
  final _equiposController = TextEditingController();
  final _trabajadoresController = TextEditingController();
  final _seguridadController = TextEditingController();

  static const int _totalPasos = totalPasosVerificacion;
  double _avance = 0;

  @override
  void initState() {
    super.initState();
    final desc = widget.dto.descripcion;
    _coordenadasController.text = desc?.coordenadas??'';
    _zonaController.text = desc?.zona??'';
    _actividadController.text = desc?.actividad??'';
    _equiposController.text = desc?.equipos??'';
    _trabajadoresController.text = desc?.trabajadores??'';
    _seguridadController.text = desc?.condicionesLaborales??'';
    _avance = calcularAvance(widget.dto);
  }

  @override
  void dispose() {
    _coordenadasController.dispose();
    _zonaController.dispose();
    _actividadController.dispose();
    _equiposController.dispose();
    _trabajadoresController.dispose();
    _seguridadController.dispose();
    super.dispose();
  }

  Future<void> _siguiente() async {
    if (_formKey.currentState!.validate()) {
      final descripcion = DescripcionActividadVerificada(
        coordenadas: _coordenadasController.text,
        zona: _zonaController.text,
        actividad: _actividadController.text,
        equipos: _equiposController.text,
        trabajadores: _trabajadoresController.text,
        condicionesLaborales: _seguridadController.text,
      );
      final dtoActualizado = RealizarVerificacionDto(
        idVerificacion: widget.dto.idVerificacion,
        idVisita: widget.dto.idVisita,
        idUsuario: widget.dto.idUsuario,
        fechaInicioMovil: widget.dto.fechaInicioMovil,
        fechaFinMovil: widget.dto.fechaFinMovil,
        proveedorSnapshot: widget.dto.proveedorSnapshot,
        actividades: widget.dto.actividades,
        descripcion: Descripcion(
          coordenadas: descripcion.coordenadas,
          zona: descripcion.zona,
          actividad: descripcion.actividad,
          equipos: descripcion.equipos,
          trabajadores: descripcion.trabajadores,
          condicionesLaborales: descripcion.condicionesLaborales,
        ),
        evaluacion: widget.dto.evaluacion,
        estimacion: widget.dto.estimacion,
        fotos: widget.dto.fotos,
        idempotencyKey: widget.dto.idempotencyKey,
      );
      await widget.verificacionRepository.guardarVerificacion(dtoActualizado);
      _avance = calcularAvance(dtoActualizado);
      if (!mounted) return;
      setState(() {});
      context.push('/flujo-visita/registro-fotografico',
          extra: {
            'actividad': widget.actividad,
            'flagMedicionCapacidad': widget.flagMedicionCapacidad,
            'flagEstimacionProduccion': widget.flagEstimacionProduccion,
            'dto': dtoActualizado,
          });
    }
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
                  'Descripción Actividad Verificada',
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
              TextFormField(
                controller: _coordenadasController,
                decoration: const InputDecoration(
                  labelText: 'Coordenadas, ubicación geográfica y política',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zonaController,
                decoration: const InputDecoration(
                  labelText: 'Zona de la labor minera',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _actividadController,
                decoration: const InputDecoration(
                  labelText: 'Actividad minera verificada',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _equiposController,
                decoration: const InputDecoration(
                  labelText: 'Equipos y maquinaria',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _trabajadoresController,
                decoration: const InputDecoration(
                  labelText: 'Trabajadores',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _seguridadController,
                decoration: const InputDecoration(
                  labelText:
                      'Trabajo forzado/infantil, medio ambiente y seguridad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomBar: BottomNavActions(
        onNext: _siguiente,
        onBack: () => context.pop(),
      ),
    );
  }
}

