// Modelo simple de reseña
class Review {
  final String id;
  final String reservationId;
  final String userId;
  final String professionalId;
  final String content;
  final int rating; // 1-5 estrellas
  final DateTime createdAt;

  Review({
    required this.id,
    required this.reservationId,
    required this.userId,
    required this.professionalId,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  // Convertir a Map para guardar
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reservationId': reservationId,
      'userId': userId,
      'professionalId': professionalId,
      'content': content,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Crear desde Map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      reservationId: map['reservationId'] ?? '',
      userId: map['userId'] ?? '',
      professionalId: map['professionalId'] ?? '',
      content: map['content'] ?? '',
      rating: map['rating'] ?? 5,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Obtener estrellas como string
  String get starsString => '⭐' * rating;
}

