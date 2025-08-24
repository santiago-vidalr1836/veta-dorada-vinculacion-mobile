import 'package:flutter/material.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/red/cliente_http.dart';
import '../../../../core/servicios/servicio_bd_local.dart';
import '../../datos/fuentes_datos/visits_local_data_source.dart';
import '../../datos/fuentes_datos/visits_remote_data_source.dart';
import '../../datos/repositorios/visits_repository_impl.dart';
import '../../dominio/entidades/visita.dart';
import '../bloc/visitas_bloc.dart';
import '../componentes/pestana_personalizada.dart';
import '../componentes/visita_card.dart';
import '../../../flujo_visita/datos/fuentes_datos/verificacion_local_data_source.dart';
import '../../../flujo_visita/datos/repositorios/verificacion_repository_impl.dart';
import '../../../flujo_visita/dominio/repositorios/verificacion_repository.dart';

/// Página que muestra las visitas organizadas en pestañas.
class VisitasTabsPage extends StatefulWidget {
  const VisitasTabsPage({super.key});

  @override
  State<VisitasTabsPage> createState() => _VisitasTabsPageState();
}

class _VisitasTabsPageState extends State<VisitasTabsPage> {
  late VisitasBloc _bloc;
  late VerificacionRepository _verificacionRepository;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inicializado) return;
    final auth = AuthProvider.of(context);
    final remoto = VisitsRemoteDataSource(ClienteHttp(token: auth.token!));
    final local = VisitsLocalDataSource(ServicioBdLocal());
    final repo = VisitsRepositoryImpl(remoto, local);
    final verificacionLocal =
        VerificacionLocalDataSource(ServicioBdLocal());
    _verificacionRepository =
        VerificacionRepositoryImpl(verificacionLocal);
    _bloc = VisitasBloc(repo, _verificacionRepository)
      ..add(CargarVisitas(auth.usuario!.id));
    _bloc.stream.listen((state) {
      if (state is VisitasCargadas && state.advertencia != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.advertencia!)));
        });
      }
    });
    _inicializado = true;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Visitas verificaciones y soportes',
          style: TextStyle(fontSize: 22),),
          const SizedBox(height: 25),
          const TabBar(
            indicatorColor: Color.fromRGBO(0, 78, 133, 1),
            labelColor: Color.fromRGBO(0, 78, 133, 1),
            tabs: [
              PestanaPersonalizada(titulo: 'Programadas'),
              PestanaPersonalizada(titulo: 'Borrador'),
              PestanaPersonalizada(titulo: 'Completadas'),
            ],
          ),
          Expanded(
            child: StreamBuilder<VisitasState>(
              stream: _bloc.stream,
              initialData: _bloc.state,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state is VisitasCargando) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is VisitasCargadas) {
                  return TabBarView(
                    children: [
                      _buildList(state.programadas),
                      _buildList(state.borrador),
                      _buildList(state.completadas),
                    ],
                  );
                }
                if (state is VisitasError) {
                  return Center(child: Text(state.mensaje));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Visita> visitas) {
    if (visitas.isEmpty) {
      return const Center(child: Text('No hay visitas'));
    }
    return ListView.builder(
      itemCount: visitas.length,
      itemBuilder: (context, index) {
        final visita = visitas[index];
        return VisitaCard(
          visita: visita,
          verificacionRepository: _verificacionRepository,
        );
      },
    );
  }
}

