class Perfil{
  const Perfil({
    required this.id,
    required this.nombre
  });

  /// Identificador único del usuario.
  final int id;

  /// Nombre completo del usuario.
  final String nombre;

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      id: json['Id'] as int,
      nombre: json['Nombre'] as String
    );
  }
}