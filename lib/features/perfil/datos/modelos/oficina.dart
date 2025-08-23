class Oficina{
  const Oficina({
    required this.id,
    required this.nombre
  });

  /// Identificador único del usuario.
  final int id;

  /// Nombre completo del usuario.
  final String nombre;

  factory Oficina.fromJson(Map<String, dynamic> json) {
    return Oficina(
      id: json['Id'] as int,
      nombre: json['Nombre'] as String
    );
  }
}