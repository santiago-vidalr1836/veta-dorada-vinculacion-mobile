/// Modelo que representa la información básica de un usuario.
class Usuario {
  const Usuario({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.correo,
  });

  /// Identificador único del usuario.
  final int id;

  /// Nombre completo del usuario.
  final String nombre;

  /// Correo electrónico del usuario.
  final String correo;
  final String apellidos;

  /// Crea una instancia de [Usuario] a partir de un mapa JSON.
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['Id'] as int,
      nombre: json['Nombres'] as String,
      apellidos: json['Apellidos'] as String,
      correo: json['CorreoElectronico'] as String,
    );
  }

  /// Convierte el [Usuario] a un mapa JSON.
  Map<String, dynamic> toJson() => {
        'Id': id,
        'Nombre': nombre,
        'Correo': correo,
      };
}

