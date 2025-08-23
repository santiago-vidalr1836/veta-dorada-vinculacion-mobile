import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../actividad/datos/repositorios/actividad_repository_impl.dart';
import '../../../actividad/dominio/entidades/actividad.dart';
import '../../../actividad/dominio/entidades/tipo_actividad.dart';
import '../../../actividad/dominio/enums/origen.dart';

/// Página para registrar una actividad minera de origen REINFO.
///
/// Carga los tipos de actividad desde el [ActividadRepositoryImpl] y permite
/// seleccionar un tipo y sub tipo además de registrar información adicional
/// como coordenadas y ubicación política.
class ActividadMineraReinfoPagina extends StatefulWidget {
  const ActividadMineraReinfoPagina({
    super.key,
    required this.repository,
  });

  /// Repositorio usado para obtener los tipos de actividad.
  final ActividadRepositoryImpl repository;

  @override
  State<ActividadMineraReinfoPagina> createState() =>
      _ActividadMineraReinfoPaginaState();
}

class _ActividadMineraReinfoPaginaState
    extends State<ActividadMineraReinfoPagina> {
  final _formKey = GlobalKey<FormState>();

  List<TipoActividad> _tipos = [];
  TipoActividad? _tipoSeleccionado;
  String? _subTipoSeleccionado;
  List<String> _subTiposDisponibles = [];
  String _labelSubTipo = 'Sub Tipo';

  final Map<int, List<String>> _mapaSubTipos = {
    // Opciones de ejemplo para los sub tipos dependiendo del tipo.
    1: ['Aluvial', 'Filoniano'],
    2: ['Gravimétrico', 'Lixiviación'],
  };

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

  @override
  void initState() {
    super.initState();
    _cargarTipos();
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

  Future<void> _cargarTipos() async {
    final resultado = await widget.repository.obtenerTiposActividad();
    setState(() {
      _tipos = resultado.tipos;
    });
  }

  void _onTipoChanged(TipoActividad? tipo) {
    setState(() {
      _tipoSeleccionado = tipo;
      _subTipoSeleccionado = null;
      _subTiposDisponibles = _mapaSubTipos[tipo?.id] ?? [];
      if (tipo != null) {
        final desc = tipo.descripcion.toLowerCase();
        if (desc.contains('beneficio')) {
          _labelSubTipo = 'Tipo de Beneficio';
        } else if (desc.contains('explot')) {
          _labelSubTipo = 'Tipo de Explotación';
        } else {
          _labelSubTipo = 'Sub Tipo';
        }
      } else {
        _labelSubTipo = 'Sub Tipo';
      }
    });
  }

  void _guardar() {
    if (!_formKey.currentState!.validate() ||
        _tipoSeleccionado == null ||
        _subTipoSeleccionado == null) {
      return;
    }
    final actividad = Actividad(
      id: '',
      origen: Origen.reinfo,
      idTipoActividad: _tipoSeleccionado!.id,
      idSubTipoActividad:
          _subTiposDisponibles.indexOf(_subTipoSeleccionado!) + 1,
      sistemaUTM: int.tryParse(_sistemaController.text) ?? 0,
      utmEste: double.tryParse(_comp01EsteController.text) ?? 0,
      utmNorte: double.tryParse(_comp01NorteController.text) ?? 0,
      zonaUTM: int.tryParse(_zonaController.text),
      descripcion: null,
    );
    context.push('/flujo-visita/datos-proveedor', extra: actividad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad minera (REINFO)')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<TipoActividad>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de actividad',
                ),
                value: _tipoSeleccionado,
                items: _tipos
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.descripcion),
                        ))
                    .toList(),
                onChanged: _onTipoChanged,
                validator: (value) =>
                    value == null ? 'Seleccione el tipo de actividad' : null,
              ),
              const SizedBox(height: 16),
              if (_subTiposDisponibles.isNotEmpty)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: _labelSubTipo),
                  value: _subTipoSeleccionado,
                  items: _subTiposDisponibles
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _subTipoSeleccionado = value),
                  validator: (value) =>
                      value == null ? 'Seleccione una opción' : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sistemaController,
                decoration:
                    const InputDecoration(labelText: 'Sistema UTM'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zonaController,
                decoration: const InputDecoration(labelText: 'Zona'),
              ),
              const SizedBox(height: 16),
              const Text('Coordenadas Componente 01'),
              TextFormField(
                controller: _comp01EsteController,
                decoration: const InputDecoration(labelText: 'Este'),
              ),
              TextFormField(
                controller: _comp01NorteController,
                decoration: const InputDecoration(labelText: 'Norte'),
              ),
              const SizedBox(height: 16),
              const Text('Coordenadas Componente 02'),
              TextFormField(
                controller: _comp02EsteController,
                decoration: const InputDecoration(labelText: 'Este'),
              ),
              TextFormField(
                controller: _comp02NorteController,
                decoration: const InputDecoration(labelText: 'Norte'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departamentoController,
                decoration:
                    const InputDecoration(labelText: 'Departamento'),
              ),
              TextFormField(
                controller: _provinciaController,
                decoration: const InputDecoration(labelText: 'Provincia'),
              ),
              TextFormField(
                controller: _distritoController,
                decoration: const InputDecoration(labelText: 'Distrito'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _derechoMineroController,
                decoration:
                    const InputDecoration(labelText: 'Derecho minero'),
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

