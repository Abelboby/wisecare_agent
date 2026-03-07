import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:wisecare_agent/utils/file_reader_stub.dart'
    if (dart.library.io) 'package:wisecare_agent/utils/file_reader_io.dart'
    as file_reader;

import 'package:wisecare_agent/models/profile/profile_model.dart';
import 'package:wisecare_agent/navigation/app_navigator.dart';
import 'package:wisecare_agent/navigation/routes.dart';
import 'package:wisecare_agent/repositories/profile_repository.dart';
import 'package:wisecare_agent/services/auth_service.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepository();

  final ProfileRepository _profileRepository;

  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUploadingPhoto = false;
  bool get isUploadingPhoto => _isUploadingPhoto;

  bool _isProfileLoading = false;
  bool get isProfileLoading => _isProfileLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _profileLoaded = false;

  /// Loads the user profile from GET /users/me. Safe to call multiple times;
  /// subsequent calls after the first successful load are no-ops unless [forceRefresh] is true.
  Future<void> loadProfile({bool forceRefresh = false}) async {
    if (forceRefresh) _profileLoaded = false;
    if (_profileLoaded || _isProfileLoading) return;
    _isProfileLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _profile = await _profileRepository.getProfile();
      _profileLoaded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  /// Picks an image, uploads via POST /uploads, then updates profile with the URL.
  Future<void> uploadProfilePhoto() async {
    if (_isLoading) return;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.single;
      List<int>? bytes = file.bytes;
      if (bytes == null && file.path != null) {
        bytes = await file_reader.readFileBytes(file.path!);
      }
      if (bytes == null || bytes.isEmpty) {
        _errorMessage = 'Could not read file.';
        notifyListeners();
        return;
      }
      final base64Data = base64Encode(bytes);
      final fileName = file.name.isNotEmpty ? file.name : 'profile-photo.jpg';
      final fileType = _mimeFromExtension(fileName);
      _isLoading = true;
      _isUploadingPhoto = true;
      _errorMessage = null;
      notifyListeners();
      final url = await _profileRepository.uploadFile(
        base64Data: base64Data,
        fileType: fileType,
        fileName: fileName,
        folder: 'profile-photos',
      );
      _profile = await _profileRepository.updateProfile(
        UpdateProfileRequest(profilePhotoUrl: url),
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
    } finally {
      _isLoading = false;
      _isUploadingPhoto = false;
      notifyListeners();
    }
  }

  static String _mimeFromExtension(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  /// Updates profile fields via PUT /users/me.
  Future<void> updateProfileDetails(UpdateProfileRequest request) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _profile = await _profileRepository.updateProfile(request);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates emergency contacts list via PUT /users/me/emergency-contact.
  Future<void> updateEmergencyContacts(List<EmergencyContact> contacts) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _profileRepository.updateEmergencyContacts(contacts);
      _profile = await _profileRepository.getProfile();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates app settings via PUT /users/me/settings.
  Future<void> updateSettings(ProfileSettings settings) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final updated = await _profileRepository.updateSettings(settings);
      if (_profile != null) {
        _profile = _profile!.copyWith(settings: updated);
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs out: revokes tokens on server, clears local state, navigates to login.
  Future<void> signOut() async {
    if (_isLoading) return;
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();
    try {
      await AuthService.signOut();
      _profile = null;
      _profileLoaded = false;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      AppNavigator.navigate(AppRoutes.login);
    } catch (e) {
      _errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
