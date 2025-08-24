import 'package:flutter/material.dart';
import 'package:veta_dorada_vinculacion_mobile/features/visitas/dominio/entidades/visita.dart';

import '../../datos/repositorios/general_repository.dart';
import '../../dominio/entidades/inicio_proceso_formalizacion.dart';
import '../../dominio/entidades/tipo_proveedor.dart';

/// Página para registrar los datos del proveedor de mineral.
///
/// Muestra un formulario para registrar la información del proveedor.
class DatosProveedorMineralPagina extends StatefulWidget {
  const DatosProveedorMineralPagina({
    super.key,
    required this.visita,
    required this.repository,
  });

  final Visita visita;
  final GeneralRepository repository;

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

  List<TipoProveedor> _tiposPersona = [];
  TipoProveedor? _tipoPersona;
  List<InicioProcesoFormalizacion> _iniciosFormalizacion = [];
  InicioProcesoFormalizacion? _inicioFormalizacion;

  @override
  void initState() {
    super.initState();
    final proveedor = widget.visita.proveedor;
    _nombreController.text = proveedor.nombreCompleto ?? '';
    _rucController.text = proveedor.ruc;
    _razonSocialController.text = proveedor.razonSocial ?? '';
    _representanteController.text = proveedor.representanteNombre ?? '';
    _cargarCatalogos();
  }

  Future<void> _cargarCatalogos() async {
    final tipos = await widget.repository.obtenerTiposProveedor();
    final inicios = await widget.repository.obtenerIniciosFormalizacion();
    setState(() {
      _tiposPersona = tipos.tipos;
      _iniciosFormalizacion = inicios.inicios;
      for (final tipo in _tiposPersona) {
        if (tipo.id == widget.visita.proveedor.tipo.codigo) {
          _tipoPersona = tipo;
          break;
        }
      }
      if (_inicioFormalizacion != null) {
        for (final inicio in _iniciosFormalizacion) {
          if (inicio.id == _inicioFormalizacion!.id) {
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
    if (_tipoPersona!.id == TIPO_PERSONA_NATURAL) {
      return _nombreController.text.isNotEmpty;
    }
    if (_tipoPersona!.id == TIPO_PERSONA_JURIDICA) {
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
              DropdownButtonFormField<TipoProveedor>(
                value: _tipoPersona,
                decoration: const InputDecoration(labelText: 'Tipo de persona'),
                items: _tiposPersona
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.descripcion),
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
              if (_tipoPersona?.id == TIPO_PERSONA_NATURAL) ...[
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
              if (_tipoPersona?.id == TIPO_PERSONA_JURIDICA) ...[
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
              DropdownButtonFormField<InicioProcesoFormalizacion>(
                value: _inicioFormalizacion,
                decoration: const InputDecoration(
                    labelText: 'Inicio de Proceso de Formalización'),
                items: _iniciosFormalizacion
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.descripcion),
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

