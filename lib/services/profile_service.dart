import 'package:dio/dio.dart';

import 'package:wisecare_agent/models/profile/profile_model.dart';
import 'package:wisecare_agent/network/dio_helper.dart';
import 'package:wisecare_agent/network/endpoints.dart';

/// Profile API service. Auth token is injected by DioHelper's JwtInterceptor.
class ProfileService {
  /// GET /users/me — returns the full profile including settings.
  Future<ProfileModel> getProfile() async {
    try {
      final response = await DioHelper.instance.get<Map<String, dynamic>>(
        Endpoints.usersMe,
      );
      final data = response.data;
      if (data == null) throw Exception('Invalid response from server.');
      final user = data['user'];
      if (user == null || user is! Map<String, dynamic>) {
        throw Exception('Invalid profile data from server.');
      }
      return ProfileModel.fromJson(user);
    } on DioException catch (e) {
      throw Exception(_messageFromDioException(e));
    }
  }

  /// PUT /users/me/settings — updates notification sounds and/or font size.
  Future<ProfileSettings> updateSettings(ProfileSettings settings) async {
    try {
      final response = await DioHelper.instance.put<Map<String, dynamic>>(
        Endpoints.usersMeSettings,
        data: settings.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      final data = response.data;
      if (data == null) throw Exception('Invalid response from server.');
      final updated = data['settings'];
      if (updated is Map<String, dynamic>) {
        return ProfileSettings.fromJson(updated);
      }
      return settings;
    } on DioException catch (e) {
      throw Exception(_messageFromDioException(e));
    }
  }

  /// PUT /users/me — update profile fields. Fetches full profile after update.
  Future<ProfileModel> updateProfile(UpdateProfileRequest request) async {
    try {
      await DioHelper.instance.put<Map<String, dynamic>>(
        Endpoints.usersMe,
        data: request.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );
      return getProfile();
    } on DioException catch (e) {
      throw Exception(_messageFromDioException(e));
    }
  }

  /// PUT /users/me/emergency-contact — update emergency contacts (full list).
  Future<void> updateEmergencyContacts(List<EmergencyContact> contacts) async {
    try {
      await DioHelper.instance.put<Map<String, dynamic>>(
        Endpoints.usersMeEmergencyContact,
        data: <String, dynamic>{
          'emergencyContacts': contacts.map((e) => e.toJson()).toList(),
        },
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (e) {
      throw Exception(_messageFromDioException(e));
    }
  }

  static String _messageFromDioException(DioException e) {
    final response = e.response;
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      final msg = data['error'] as String? ?? data['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    }
    if (response?.statusCode != null) {
      if (response!.statusCode! == 401) {
        return 'Session expired. Please sign in again.';
      }
      if (response.statusCode! == 404) return 'Profile not found.';
      if (response.statusCode! >= 500) {
        return 'Server error. Please try again later.';
      }
    }
    if (response == null || e.type == DioExceptionType.connectionError) {
      return 'Network error. Please check your connection.';
    }
    return e.message ?? 'Something went wrong. Please try again.';
  }
}
