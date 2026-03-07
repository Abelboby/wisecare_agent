import 'package:dio/dio.dart';

import 'package:wisecare_agent/utils/static_values.dart';
import 'package:wisecare_agent/network/jwt_interceptor.dart';

/// Singleton Dio instance with base URL, timeouts, and JWT interceptor.
class DioHelper {
  DioHelper._();

  static Dio? _dio;

  static Dio get instance {
    if (_dio != null) return _dio!;
    _dio = Dio(
      BaseOptions(
        baseUrl: StaticValues.apiBaseUrl,
        connectTimeout: Duration(milliseconds: StaticValues.connectTimeout),
        receiveTimeout: Duration(milliseconds: StaticValues.receiveTimeout),
      ),
    );
    // Pass the Dio instance into the interceptor so it can retry requests
    // after a successful token refresh.
    _dio!.interceptors.add(JwtInterceptor(dio: _dio!));
    return _dio!;
  }
}
