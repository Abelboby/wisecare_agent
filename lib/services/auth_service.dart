import 'package:dio/dio.dart';

import 'package:wisecare_agent/models/auth/login_response_model.dart';
import 'package:wisecare_agent/network/endpoints.dart';
import 'package:wisecare_agent/network/dio_helper.dart';
import 'package:wisecare_agent/services/auth_storage_service.dart';

/// Auth API: signin (email/password). Uses [DioHelper.instance].
class AuthService {
  AuthService._();

  static Future<LoginResponseModel> signInWithEmail(
      String email, String password) async {
    try {
      final dio = DioHelper.instance;
      final response = await dio.post<Map<String, dynamic>>(
        Endpoints.authSignin,
        data: <String, String>{
          'email': email,
          'password': password,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Invalid response from server.');
      }
      final model = LoginResponseModel.fromJson(
        Map<String, dynamic>.from(data),
      );
      if (model.accessToken.isEmpty) {
        throw Exception('Invalid response from server.');
      }
      await AuthStorageService.saveAuthTokens(
        model.accessToken,
        model.refreshToken ?? '',
      );
      return model;
    } on DioException catch (e) {
      final message = _messageFromDioException(e);
      throw Exception(message);
    }
  }

  static String _messageFromDioException(DioException e) {
    final response = e.response;
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      final msg = data['message'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    }
    if (response?.statusCode != null) {
      if (response!.statusCode! == 400) {
        return 'Please enter your email and password.';
      }
      if (response.statusCode! == 401) {
        return 'Invalid email or password.';
      }
      if (response.statusCode! >= 500) {
        return 'Server error. Please try again later.';
      }
    }
    if (response == null ||
        e.type == DioExceptionType.connectionError ||
        (e.message?.contains('XMLHttpRequest') ?? false)) {
      return 'Network error. If you\'re on web, the server may not allow this app (CORS). Try mobile/desktop or check your connection.';
    }
    return e.message ?? 'Something went wrong. Please try again.';
  }

  /// Revokes refresh token on server, then clears local tokens.
  static Future<void> signOut() async {
    final refreshToken = AuthStorageService.getStoredRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final dio = DioHelper.instance;
        await dio.post<Map<String, dynamic>>(
          Endpoints.authSignout,
          data: <String, String>{'refreshToken': refreshToken},
          options: Options(contentType: Headers.jsonContentType),
        );
      }
    } on DioException catch (_) {
      // Best effort: still clear tokens and sign out locally
    } finally {
      await AuthStorageService.clearAuthTokens();
    }
  }
}
