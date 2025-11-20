import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/professional_profile.dart';

class ProfileService extends ChangeNotifier {
  UserProfile? _userProfile;
  ProfessionalProfile? _professionalProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  ProfessionalProfile? get professionalProfile => _professionalProfile;
  bool get isLoading => _isLoading;
  bool get isProfessional => _userProfile?.role == 'professional';

  Future<void> loadUserProfile(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(milliseconds: 500));

      _userProfile = UserProfile(
        userId: userId,
        firstName: 'Anáis',
        secondName: 'Yoselin',
        firstName_surname: 'Flores',
        secondSurname: 'Halanocca',
        email: 'anais.flores@example.com',
        phoneNumber: '+51 991 457 273',
        photoUrl: null,
        role: 'professional',
        registrationDate: DateTime.now().subtract(Duration(days: 180)),
      );

      if (_userProfile?.role == 'professional') {
        _professionalProfile = ProfessionalProfile(
          profileId: 1,
          userId: userId,
          experience:
              '5 años de experiencia en desarrollo de aplicaciones móviles y web. He trabajado en varios proyectos exitosos con Flutter, React y Node.js.',
          presentation:
              'Desarrolladora especializada en crear soluciones digitales innovadoras y de alta calidad.',
          averageRating: 4.8,
          totalReviews: 12,
          specializations: ['Flutter', 'Mobile Development', 'UI/UX Design'],
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(milliseconds: 500));
      _userProfile = profile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

