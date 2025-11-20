/// Modelo que representa una especialización de una profesión
class Specialization {
  final int specializationId;
  final int professionId;
  final String specializationName;
  final String description;

  Specialization({
    required this.specializationId,
    required this.professionId,
    required this.specializationName,
    required this.description,
  });

  /// Crear instancia desde JSON (para futuro consumo de API)
  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      specializationId: json['specialization_id'] ?? 0,
      professionId: json['profession_id'] ?? 0,
      specializationName: json['specialization_name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() => {
    'specialization_id': specializationId,
    'profession_id': professionId,
    'specialization_name': specializationName,
    'description': description,
  };

  @override
  String toString() => 'Specialization(id: $specializationId, name: $specializationName, professionId: $professionId)';
}

