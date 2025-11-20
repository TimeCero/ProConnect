/// Modelo que representa una categoría de profesión
class ProfessionCategory {
  final int categoryId;
  final String categoryName;
  final String? description;

  ProfessionCategory({
    required this.categoryId,
    required this.categoryName,
    this.description,
  });

  /// Crear instancia desde JSON (para futuro consumo de API)
  factory ProfessionCategory.fromJson(Map<String, dynamic> json) {
    return ProfessionCategory(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      description: json['description'],
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() => {
    'category_id': categoryId,
    'category_name': categoryName,
    'description': description,
  };

  @override
  String toString() => 'ProfessionCategory(id: $categoryId, name: $categoryName)';
}

