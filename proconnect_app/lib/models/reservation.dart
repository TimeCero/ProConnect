// Modelo que representa una reserva de espacio.
// Cada reserva está asociada a un usuario, un espacio y un profesional.
class Reservation {
  final String id; // Identificador único de la reserva
  final String userId; // ID del usuario que hizo la reserva
  final String spaceId; // ID del espacio reservado
  final String professionalId; // ID del profesional dueño del espacio
  final DateTime date; // Fecha de la reserva
  final String timeSlot; // Horario de la reserva (ej. "09:00", "14:00")
  final String status; // Estado: "pending", "confirmed", "cancelled"
  final DateTime createdAt; // Fecha de creación de la reserva

  Reservation({
    required this.id,
    required this.userId,
    required this.spaceId,
    required this.professionalId,
    required this.date,
    required this.timeSlot,
    this.status = 'pending',
    required this.createdAt,
  });

  // Método para crear una copia con algunos campos modificados
  Reservation copyWith({
    String? id,
    String? userId,
    String? spaceId,
    String? professionalId,
    DateTime? date,
    String? timeSlot,
    String? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spaceId: spaceId ?? this.spaceId,
      professionalId: professionalId ?? this.professionalId,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Método para convertir a Map (útil para persistencia)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'spaceId': spaceId,
      'professionalId': professionalId,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Método para crear desde Map (útil para cargar desde persistencia)
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      spaceId: map['spaceId'] ?? '',
      professionalId: map['professionalId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      timeSlot: map['timeSlot'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Método para verificar si la reserva está activa
  bool get isActive => status == 'confirmed' || status == 'pending';

  // Método para verificar si la reserva está cancelada
  bool get isCancelled => status == 'cancelled';
}

// Enum para los estados de reserva (opcional, pero útil)
enum ReservationStatus {
  pending,
  confirmed,
  cancelled,
}

// Método helper para convertir string a enum
ReservationStatus reservationStatusFromString(String status) {
  switch (status) {
    case 'pending':
      return ReservationStatus.pending;
    case 'confirmed':
      return ReservationStatus.confirmed;
    case 'cancelled':
      return ReservationStatus.cancelled;
    default:
      return ReservationStatus.pending;
  }
}

// Método helper para convertir enum a string
String reservationStatusToString(ReservationStatus status) {
  switch (status) {
    case ReservationStatus.pending:
      return 'pending';
    case ReservationStatus.confirmed:
      return 'confirmed';
    case ReservationStatus.cancelled:
      return 'cancelled';
  }
}
