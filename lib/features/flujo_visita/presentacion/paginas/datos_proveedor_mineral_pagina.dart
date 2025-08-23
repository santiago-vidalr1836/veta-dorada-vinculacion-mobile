import 'package:flutter/material.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/visita.dart';

import '../../../actividad/dominio/entidades/actividad.dart';

/// Página para registrar los datos del proveedor de mineral.
///
/// Muestra un formulario para registrar la información del proveedor.
class DatosProveedorMineralPagina extends StatefulWidget {
  const DatosProveedorMineralPagina({super.key, required this.visita});

  final Visita visita;

  @override
  State<DatosProveedorMineralPagina> createState() =>
      _DatosProveedorMineralPaginaState();
}

class _DatosProveedorMineralPaginaState
    extends State<DatosProveedorMineralPagina> {
  static const String TIPO_PERSONA_NATURAL = 'NATURAL';
  static const String TIPO_PERSONA_JURIDICA = 'JURIDICA';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _razonSocialController = TextEditingController();
  final TextEditingController _representanteController = TextEditingController();

  String? _tipoPersona;
  String? _inicioFormalizacion;

  @override
  void initState() {
    super.initState();
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
    if (_tipoPersona == TIPO_PERSONA_NATURAL) {
      return _nombreController.text.isNotEmpty;
    }
    if (_tipoPersona == TIPO_PERSONA_JURIDICA) {
      return _rucController.text.isNotEmpty &&
          _razonSocialController.text.isNotEmpty &&
          _representanteController.text.isNotEmpty;
    }
    return false;
  }

  void _siguiente() {
    if (_formKey.currentState!.validate()) {
      // ignore: avoid_print
      print('Visita recibida: ${widget.visita.toJson()}');
      // Navegar al siguiente paso o guardar la información.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos de proveedor de mineral')),
      body: Form(
        key: _formKey,
        onChanged: () => setState(() {}),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('8 de 9')),
              const SizedBox(height: 8),
              const LinearProgressIndicator(value: 8 / 9),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _tipoPersona,
                decoration: const InputDecoration(labelText: 'Tipo de persona'),
                items: const [
                  DropdownMenuItem(
                    value: TIPO_PERSONA_NATURAL,
                    child: Text('Persona Natural'),
                  ),
                  DropdownMenuItem(
                    value: TIPO_PERSONA_JURIDICA,
                    child: Text('Persona Jurídica'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoPersona = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione el tipo de persona' : null,
              ),
              const SizedBox(height: 16),
              if (_tipoPersona == TIPO_PERSONA_NATURAL) ...[
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onChanged: (_) => setState(() {}),
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Ingrese el nombre'
                          : null,
                ),
                const SizedBox(height: 16),
              ],
              if (_tipoPersona == TIPO_PERSONA_JURIDICA) ...[
                TextFormField(
                  controller: _rucController,
                  decoration: const InputDecoration(labelText: 'RUC'),
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
                      const InputDecoration(labelText: 'Razón Social'),
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
                      labelText: 'Nombre completo del representante legal'),
                  onChanged: (_) => setState(() {}),
                  validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Ingrese el nombre del representante'
                          : null,
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                value: _inicioFormalizacion,
                decoration: const InputDecoration(
                    labelText: 'Inicio de Proceso de Formalización'),
                items: const [
                  DropdownMenuItem(value: 'SI', child: Text('Sí')),
                  DropdownMenuItem(value: 'NO', child: Text('No')),
                ],
                onChanged: (value) {
                  setState(() {
                    _inicioFormalizacion = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una opción' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
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

