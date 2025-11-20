/// Modelo que representa una profesión
class Profession {
  final int professionId;
  final int categoryId;
  final String professionName;
  final String? description;

  Profession({
    required this.professionId,
    required this.categoryId,
    required this.professionName,
    this.description,
  });

  /// Crear instancia desde JSON (para futuro consumo de API)
  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      professionId: json['profession_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      professionName: json['profession_name'] ?? '',
      description: json['description'],
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() => {
    'profession_id': professionId,
    'category_id': categoryId,
    'profession_name': professionName,
    'description': description,
  };

  @override
  String toString() => 'Profession(id: $professionId, name: $professionName, categoryId: $categoryId)';
}

