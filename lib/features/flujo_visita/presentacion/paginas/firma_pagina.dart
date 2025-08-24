import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/auth/auth_provider.dart';
import '../../../../core/widgets/protected_scaffold.dart';
import '../../../actividad/dominio/entidades/actividad.dart';
import '../../../perfil/datos/modelos/usuario.dart';
import '../../dominio/entidades/realizar_verificacion_dto.dart';

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
      )/*,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final fecha =
                      DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
                  return Dialog(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Informe verificación generado'),
                          const SizedBox(height: 8),
                          Text('Fecha: $fecha'),
                          Text(
                              'Coordenadas: ${actividad.utmEste}, ${actividad.utmNorte}'),
                          Text(
                              'Prospecto: ${actividad.descripcion ?? '-'}'),
                          Text(
                              'Derecho minero: ${actividad.derechoMinero ?? '-'}'),
                          const Text('Condición: -'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (flagEstimacionProduccion ||
                                  flagMedicionCapacidad)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context.push(
                                      '/flujo-visita/estimacion-produccion',
                                      extra: {
                                        'flagMedicionCapacidad':
                                            flagMedicionCapacidad,
                                        'dto': dto,
                                      },
                                    );
                                  },
                                  child: const Text('Estimacion Produccion'),
                                )
                              else
                                const Text('Enviar'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  context.push('/flujo-visita/firma-digital');
                                },
                                child: const Text('Firmar digital'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const Text('Firmar'),
          ),
        ),
      ),*/
    );
  }
}

