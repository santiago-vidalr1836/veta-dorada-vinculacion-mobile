import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Página para describir la actividad minera verificada.
///
/// Muestra un formulario con varias secciones de información
/// complementaria respecto a la actividad verificada.
class DescripcionActividadMineraVerificadaPagina extends StatefulWidget {
  const DescripcionActividadMineraVerificadaPagina({super.key});

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

  void _siguiente() {
    if (_formKey.currentState!.validate()) {
      context.push('/flujo-visita/paso6');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Descripción Actividad Verificada')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('5 de 9')),
              const SizedBox(height: 8),
              const LinearProgressIndicator(value: 5 / 9),
              const SizedBox(height: 24),
              TextFormField(
                controller: _coordenadasController,
                decoration: const InputDecoration(
                  labelText: 'Coordenadas, ubicación geográfica y política',
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
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _siguiente,
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

