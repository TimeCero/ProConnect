/// Modelo que representa los datos que se envían para registrar un profesional
class ProfessionalRegistration {
  final String experience;
  final String presentation;
  final int professionCategoryId;
  final int professionId;
  final List<int> specializationIds;

  ProfessionalRegistration({
    required this.experience,
    required this.presentation,
    required this.professionCategoryId,
    required this.professionId,
    required this.specializationIds,
  });

  /// Convertir a JSON para enviar al backend
  Map<String, dynamic> toJson() => {
    'experience': experience,
    'presentation': presentation,
    'profession_category_id': professionCategoryId,
    'profession_id': professionId,
    'specialization_ids': specializationIds,
  };

  @override
  String toString() => 'ProfessionalRegistration(professionId: $professionId, categId: $professionCategoryId, specs: ${specializationIds.length})';
}

