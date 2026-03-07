import 'dart:developer' as dev;

import 'package:dio/dio.dart';

import 'package:wisecare_agent/navigation/app_navigator.dart';
import 'package:wisecare_agent/navigation/routes.dart';
import 'package:wisecare_agent/network/endpoints.dart';
import 'package:wisecare_agent/services/auth_storage_service.dart';

/// Reads access token from Hive. Called synchronously inside onRequest.
String? getStoredAuthToken() => AuthStorageService.getStoredAuthToken();

/// Key used in [RequestOptions.extra] to skip auth injection and 401-retry
/// for internal calls (e.g. the refresh request itself).
const _kSkipAuth = 'skipAuth';

/// Dio interceptor that:
///  1. Attaches `Authorization: Bearer <token>` to every non-auth request.
///  2. Logs the real outgoing headers and response status.
///  3. On 401: calls POST /auth/refresh via the same Dio (with skipAuth flag),
///     saves new tokens, retries the original request.
///  4. On refresh failure: clears tokens and redirects to login.
class JwtInterceptor extends Interceptor {
  JwtInterceptor({required Dio dio}) : _dio = dio;

  final Dio _dio;
  bool _isRefreshing = false;

  static const String _tag = 'JwtInterceptor';

  bool _shouldSkip(RequestOptions options) => options.extra[_kSkipAuth] == true || options.path.startsWith('/auth/');

  // ── Request ───────────────────────────────────────────────────────────────

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_shouldSkip(options)) {
      final token = getStoredAuthToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    dev.log(
      '[${options.method}] ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Body: ${options.data ?? "(empty)"}',
      name: _tag,
    );

    handler.next(options);
  }

  // ── Response ──────────────────────────────────────────────────────────────

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log(
      '[${response.requestOptions.method}] ${response.requestOptions.uri}'
      ' => ${response.statusCode}\n'
      'Response: ${response.data}',
      name: _tag,
    );
    handler.next(response);
  }

  // ── Error / 401 → refresh → retry ────────────────────────────────────────

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    if (statusCode != 401 || _shouldSkip(err.requestOptions)) {
      dev.log(
        '[${err.requestOptions.method} ERROR] ${err.requestOptions.uri}'
        ' => $statusCode\n'
        'Type: ${err.type} | Message: ${err.message}\n'
        'Response: ${err.response?.data}',
        name: _tag,
      );
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      handler.next(err);
      return;
    }

    _isRefreshing = true;
    dev.log('401 received — attempting token refresh.', name: _tag);

    try {
      final refreshToken = AuthStorageService.getStoredRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        dev.log('No refresh token stored — redirecting to login.', name: _tag);
        await _forceLogout();
        handler.next(err);
        return;
      }

      // Reuse _dio but mark skipAuth so this call is not intercepted again.
      final refreshResponse = await _dio.post<Map<String, dynamic>>(
        Endpoints.authRefresh,
        data: {'refreshToken': refreshToken},
        options: Options(
          contentType: Headers.jsonContentType,
          extra: {_kSkipAuth: true},
        ),
      );

      final body = refreshResponse.data;
      final newAccessToken = body?['accessToken'] as String?;
      final newRefreshToken = body?['refreshToken'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        dev.log(
          'Refresh response missing accessToken — forcing logout.',
          name: _tag,
        );
        await _forceLogout();
        handler.next(err);
        return;
      }

      dev.log('Token refreshed successfully.', name: _tag);
      await AuthStorageService.saveAuthTokens(newAccessToken, newRefreshToken);

      // Retry the original request with the new token.
      final retryOptions = err.requestOptions..headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } on DioException catch (refreshErr) {
      dev.log(
        'Token refresh failed: ${refreshErr.response?.statusCode} ${refreshErr.message}',
        name: _tag,
        error: refreshErr,
      );
      await _forceLogout();
      handler.next(err);
    } catch (e) {
      dev.log('Token refresh error: $e', name: _tag, error: e);
      await _forceLogout();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _forceLogout() async {
    await AuthStorageService.clearAuthTokens();
    AppNavigator.navigate(AppRoutes.login);
  }
}
