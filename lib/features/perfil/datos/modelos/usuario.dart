/// Modelo que representa la información básica de un usuario.
class Usuario {
  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  /// Identificador único del usuario.
  final String id;

  /// Nombre completo del usuario.
  final String nombre;

  /// Correo electrónico del usuario.
  final String correo;

  /// Crea una instancia de [Usuario] a partir de un mapa JSON.
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
    );
  }

  /// Convierte el [Usuario] a un mapa JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'correo': correo,
      };
}

