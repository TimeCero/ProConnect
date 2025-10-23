import 'space.dart';

// Modelo que representa a un profesional.
// Ahora incluye información de contacto y espacios disponibles.
class Professional {
  final String id; // Identificador único
  final String name; // Nombre completo del profesional
  final String role; // Rol o especialidad (ej. Abogada, Contador)
  final String avatarUrl; // URL de avatar (puede quedar vacío en mocks)
  final bool featured; // Si es destacado o no
  final String phone; // Teléfono de contacto
  final String email; // Email de contacto
  final String bio; // Breve descripción del profesional
  final List<Space> spaces; // Espacios que maneja este profesional

  Professional({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    this.featured = false,
    required this.phone,
    required this.email,
    this.bio = '',
    this.spaces = const [],
  });

  // Método para crear una copia con algunos campos modificados
  Professional copyWith({
    String? id,
    String? name,
    String? role,
    String? avatarUrl,
    bool? featured,
    String? phone,
    String? email,
    String? bio,
    List<Space>? spaces,
  }) {
    return Professional(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      featured: featured ?? this.featured,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      spaces: spaces ?? this.spaces,
    );
  }

  // Método para verificar si tiene espacios disponibles
  bool get hasAvailableSpaces => spaces.any((space) => space.isAvailable);

  // Método para obtener espacios disponibles
  List<Space> get availableSpaces => spaces.where((space) => space.isAvailable).toList();
}
