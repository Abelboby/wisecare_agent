import 'package:wisecare_agent/models/profile/profile_model.dart';
import 'package:wisecare_agent/services/profile_service.dart';

/// Profile data orchestration. Only this layer talks to ProfileService.
class ProfileRepository {
  ProfileRepository({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  final ProfileService _profileService;

  Future<ProfileModel> getProfile() => _profileService.getProfile();

  Future<ProfileSettings> updateSettings(ProfileSettings settings) =>
      _profileService.updateSettings(settings);

  Future<ProfileModel> updateProfile(UpdateProfileRequest request) =>
      _profileService.updateProfile(request);

  Future<void> updateEmergencyContacts(List<EmergencyContact> contacts) =>
      _profileService.updateEmergencyContacts(contacts);
}
