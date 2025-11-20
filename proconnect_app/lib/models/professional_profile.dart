class ProfessionalProfile {
  final int profileId;
  final int userId;
  final String? experience;
  final String? presentation;
  final double averageRating;
  final int totalReviews;
  final List<String> specializations;

  ProfessionalProfile({
    required this.profileId,
    required this.userId,
    this.experience,
    this.presentation,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.specializations = const [],
  });

  factory ProfessionalProfile.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfile(
      profileId: json['profile_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      experience: json['experience'],
      presentation: json['presentation'],
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      specializations: List<String>.from(json['specializations'] ?? []),
    );
  }
}

