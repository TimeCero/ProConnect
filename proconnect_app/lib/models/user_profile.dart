class UserProfile {
  final int userId;
  final String firstName;
  final String? secondName;
  final String firstName_surname;
  final String? secondSurname;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final String role; // 'client', 'professional', 'admin'
  final DateTime registrationDate;

  UserProfile({
    required this.userId,
    required this.firstName,
    this.secondName,
    required this.firstName_surname,
    this.secondSurname,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    required this.role,
    required this.registrationDate,
  });

  String get fullName => '$firstName $firstName_surname';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      secondName: json['second_name'],
      firstName_surname: json['first_surname'] ?? '',
      secondSurname: json['second_surname'],
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      photoUrl: json['photo_url'],
      role: json['role'] ?? 'client',
      registrationDate: DateTime.parse(json['registration_date'] ?? DateTime.now().toIso8601String()),
    );
  }
}

