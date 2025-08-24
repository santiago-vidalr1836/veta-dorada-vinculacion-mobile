import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/servicios/servicio_bd_local.dart';
import '../../../../core/widgets/bottom_nav_actions.dart';
import '../../../../core/widgets/protected_scaffold.dart';
import '../../../actividad/dominio/entidades/actividad.dart';
import '../../../perfil/datos/modelos/usuario.dart';
import '../../../visitas/dominio/entidades/estado_visita.dart';
import '../../datos/fuentes_datos/verificacion_local_data_source.dart';
import '../../datos/repositorios/verificacion_repository_impl.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';
import '../../dominio/repositorios/verificacion_repository.dart';

/// Página para visualizar la información del usuario antes de firmar.
class FirmaPagina extends StatelessWidget {
  const FirmaPagina({
    super.key,
    required this.actividad,
    required this.usuario,
    required this.flagMedicionCapacidad,
    required this.flagEstimacionProduccion,
    required this.dto,
  });

  /// Actividad asociada a la firma.
  final Actividad actividad;

  /// Usuario que realizará la firma.
  final Usuario usuario;

  /// Indica si la visita requiere medición de capacidad.
  final bool flagMedicionCapacidad;

  /// Indica si la visita requiere estimación de producción.
  final bool flagEstimacionProduccion;

  /// Datos actuales de la verificación.
  final RealizarVerificacionDto dto;

  Future<void> _marcarVisitaCompletada(int idVisita) async {
    final bd = ServicioBdLocal();
    final rows = await bd.query(
      ServicioBdLocal.nombreTablaVisitas,
      where: 'id = ?',
      whereArgs: [idVisita.toString()],
    );
    if (rows.isEmpty) return;
    final data =
        jsonDecode(rows.first['data'] as String) as Map<String, dynamic>;
    if (data['Estado'] is Map<String, dynamic>) {
      final estado = data['Estado'] as Map<String, dynamic>;
      estado['Codigo'] = EstadoVisita.realizada;
      estado['Nombre'] = 'Realizada';
    } else {
      data['Estado'] = {
        'Codigo': EstadoVisita.realizada,
        'Nombre': 'Realizada',
      };
    }
    await bd.update(
      ServicioBdLocal.nombreTablaVisitas,
      {
        'estado': EstadoVisita.realizada,
        'data': jsonEncode(data),
      },
      where: 'id = ?',
      whereArgs: [idVisita.toString()],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Se obtiene el usuario autenticado por si cambia durante la navegación.
    final auth = AuthProvider.of(context);
    final currentUser = auth.usuario ?? usuario;

    return ProtectedScaffold(
      usuario: auth.usuario!,
      token: auth.token!,
      onNavigate: (ruta) => context.go(ruta),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 378,
              child: Text(
                'Firma',
                style: TextStyle(
                  color: Color(0xFF1D1B20),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 1.27,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('DNI: ${currentUser.id}'),
            const SizedBox(height: 8),
            Text('Nombre y apellidos: ${currentUser.nombre}'),
            const SizedBox(height: 8),
            Text('Cargo: ${currentUser.correo}'),
            const SizedBox(height: 8),
            const Text('Jefatura: -'),
          ],
        ),
      ),
      bottomBar: BottomNavActions(
        onNext: () async {
          final VerificacionRepository repo = VerificacionRepositoryImpl(
            VerificacionLocalDataSource(ServicioBdLocal()),
          );
          final dtoActualizado =
              dto.copyWith(fechaFinMovil: DateTime.now());
          await repo.guardarVerificacion(dtoActualizado);
          await _marcarVisitaCompletada(dto.idVisita);
          if (flagMedicionCapacidad || flagEstimacionProduccion) {
            context.push('/flujo-visita/estimacion-produccion', extra: {
              'flagMedicionCapacidad': flagMedicionCapacidad,
              'dto': dtoActualizado,
            });
          } else {
            context.go('/visitas');
          }
        },
        onBack: () => context.pop(),
        nextText: 'Confirmar',
      ),
    );
  }
}

