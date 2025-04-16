class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  final List<Map<String, dynamic>> _profiles = [];

  List<Map<String, dynamic>> getAllProfiles() {
    return List.from(_profiles);
  }

  void addProfile(Map<String, dynamic> profile) {
    _profiles.add(profile);
  }

  void updateProfile(int index, Map<String, dynamic> newProfile) {
    if (index >= 0 && index < _profiles.length) {
      _profiles[index] = newProfile;
    }
  }

  void deleteProfile(int index) {
    if (index >= 0 && index < _profiles.length) {
      _profiles.removeAt(index);
    }
  }

  void clearAllProfiles() {
    _profiles.clear();
  }
}
