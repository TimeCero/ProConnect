// Modelo simple que representa a un profesional.
// Lo usamos para crear objetos con datos que la UI consumirá.
class Professional {
  final String id; // Identificador único
  final String name; // Nombre completo del profesional
  final String role; // Rol o especialidad (ej. Abogada, Contador)
  final String avatarUrl; // URL de avatar (puede quedar vacío en mocks)
  final bool featured; // Si es destacado o no

  Professional({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    this.featured = false,
  });
}
