import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reservation.dart';
import '../models/review.dart';

/// Servicio para manejar reservas de espacios.
/// Guarda las reservas localmente en SharedPreferences.
class ReservationService extends ChangeNotifier {
  List<Reservation> _reservations = [];
  List<Review> _reviews = [];
  String? _currentUserId; // ID del usuario actual

  List<Reservation> get reservations => _reservations;
  String? get currentUserId => _currentUserId;

  ReservationService() {
    _loadReservations();
    _loadReviews();
  }

  /// Inicializa el servicio con el usuario actual
  void initializeWithUser(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  /// Establece el usuario actual
  void setCurrentUser(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  /// Carga las reservas desde SharedPreferences
  Future<void> _loadReservations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reservationsJson = prefs.getString('reservations') ?? '[]';
      final List<dynamic> reservationsList = json.decode(reservationsJson);
      
      _reservations = reservationsList
          .map((json) => Reservation.fromMap(json))
          .toList();
      
      notifyListeners();
    } catch (e) {
      _reservations = [];
    }
  }


  /// Guarda las reservas en SharedPreferences
  Future<void> _saveReservations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reservationsJson = json.encode(
        _reservations.map((r) => r.toMap()).toList(),
      );
      await prefs.setString('reservations', reservationsJson);
    } catch (e) {
      print('Error guardando reservas: $e');
    }
  }

  /// Crea una nueva reserva
  Future<String?> createReservation({
    required String spaceId,
    required String professionalId,
    required DateTime date,
    required String timeSlot,
  }) async {
    if (_currentUserId == null) {
      return 'Usuario no autenticado';
    }

    // Verificar si ya existe una reserva para el mismo espacio, fecha y hora
    final existingReservation = _reservations.any((r) =>
        r.spaceId == spaceId &&
        r.date.year == date.year &&
        r.date.month == date.month &&
        r.date.day == date.day &&
        r.timeSlot == timeSlot &&
        r.status != 'cancelled');

    if (existingReservation) {
      return 'Ya existe una reserva para este espacio en la fecha y hora seleccionada';
    }

    // Crear nueva reserva
    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _currentUserId!,
      spaceId: spaceId,
      professionalId: professionalId,
      date: date,
      timeSlot: timeSlot,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    _reservations.add(reservation);
    await _saveReservations();
    notifyListeners();

    return null; // Sin errores
  }

  /// Obtiene las reservas del usuario actual
  List<Reservation> getUserReservations() {
    if (_currentUserId == null) return [];
    
    return _reservations
        .where((r) => r.userId == _currentUserId)
        .toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Más recientes primero
  }

  /// Cancela una reserva
  Future<String?> cancelReservation(String reservationId) async {
    final reservationIndex = _reservations.indexWhere((r) => r.id == reservationId);
    
    if (reservationIndex == -1) {
      return 'Reserva no encontrada';
    }

    final reservation = _reservations[reservationIndex];
    
    if (reservation.status == 'cancelled') {
      return 'La reserva ya está cancelada';
    }

    // Actualizar estado a cancelado
    _reservations[reservationIndex] = reservation.copyWith(status: 'cancelled');
    await _saveReservations();
    notifyListeners();

    return null; // Sin errores
  }

  /// Verifica si un slot está disponible
  bool isSlotAvailable(String spaceId, DateTime date, String timeSlot) {
    return !_reservations.any((r) =>
        r.spaceId == spaceId &&
        r.date.year == date.year &&
        r.date.month == date.month &&
        r.date.day == date.day &&
        r.timeSlot == timeSlot &&
        r.status != 'cancelled');
  }

  /// Obtiene los slots disponibles para un espacio en una fecha específica
  List<String> getAvailableTimeSlots(String spaceId, DateTime date) {
    final allSlots = [
      '09:00', '10:00', '11:00', '12:00',
      '14:00', '15:00', '16:00', '17:00'
    ];

    return allSlots.where((slot) => 
        isSlotAvailable(spaceId, date, slot)
    ).toList();
  }

  /// Confirma una reserva (para uso futuro)
  Future<String?> confirmReservation(String reservationId) async {
    final reservationIndex = _reservations.indexWhere((r) => r.id == reservationId);
    
    if (reservationIndex == -1) {
      return 'Reserva no encontrada';
    }

    _reservations[reservationIndex] = _reservations[reservationIndex].copyWith(
      status: 'confirmed'
    );
    
    await _saveReservations();
    notifyListeners();

    return null;
  }

  // ========== MÉTODOS DE RESEÑAS ==========

  /// Carga reseñas desde SharedPreferences
  Future<void> _loadReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reviewsJson = prefs.getString('reviews') ?? '[]';
      final List<dynamic> reviewsList = json.decode(reviewsJson);
      
      _reviews = reviewsList.map((json) => Review.fromMap(json)).toList();
    } catch (e) {
      _reviews = [];
    }
  }

  /// Guarda reseñas en SharedPreferences
  Future<void> _saveReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reviewsJson = json.encode(_reviews.map((r) => r.toMap()).toList());
      await prefs.setString('reviews', reviewsJson);
    } catch (e) {
      print('Error guardando reseñas: $e');
    }
  }

  /// Crea una nueva reseña
  Future<String?> createReview({
    required String reservationId,
    required String professionalId,
    required String content,
    required int rating,
  }) async {
    if (_currentUserId == null) {
      return 'Usuario no autenticado';
    }

    // Verificar que no existe ya una reseña
    if (_reviews.any((r) => r.reservationId == reservationId)) {
      return 'Ya existe una reseña para esta cita';
    }

    // Validar rating
    if (rating < 1 || rating > 5) {
      return 'La calificación debe estar entre 1 y 5';
    }

    // Validar contenido
    if (content.trim().isEmpty) {
      return 'El contenido es requerido';
    }

    // Crear reseña
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      reservationId: reservationId,
      userId: _currentUserId!,
      professionalId: professionalId,
      content: content.trim(),
      rating: rating,
      createdAt: DateTime.now(),
    );

    _reviews.add(review);
    await _saveReviews();
    notifyListeners();

    return null; // Sin errores
  }

  /// Obtiene la reseña de una reserva
  Review? getReviewForReservation(String reservationId) {
    try {
      return _reviews.firstWhere((r) => r.reservationId == reservationId);
    } catch (e) {
      return null;
    }
  }
}
