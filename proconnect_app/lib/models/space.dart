// Modelo que representa un espacio disponible para reservar.
// Cada profesional puede tener múltiples espacios.
class Space {
  final String id; // Identificador único del espacio
  final String professionalId; // ID del profesional que maneja este espacio
  final String name; // Nombre del espacio (ej. "Consultorio", "Sala de reuniones")
  final String description; // Descripción breve del espacio
  final double price; // Precio por hora del espacio
  final bool isAvailable; // Si el espacio está disponible para reservas

  Space({
    required this.id,
    required this.professionalId,
    required this.name,
    required this.description,
    required this.price,
    this.isAvailable = true,
  });

  // Método para crear una copia con algunos campos modificados
  Space copyWith({
    String? id,
    String? professionalId,
    String? name,
    String? description,
    double? price,
    bool? isAvailable,
  }) {
    return Space(
      id: id ?? this.id,
      professionalId: professionalId ?? this.professionalId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  // Método para convertir a Map (útil para persistencia)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'professionalId': professionalId,
      'name': name,
      'description': description,
      'price': price,
      'isAvailable': isAvailable,
    };
  }

  // Método para crear desde Map (útil para cargar desde persistencia)
  factory Space.fromMap(Map<String, dynamic> map) {
    return Space(
      id: map['id'] ?? '',
      professionalId: map['professionalId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      isAvailable: map['isAvailable'] ?? true,
    );
  }
}
