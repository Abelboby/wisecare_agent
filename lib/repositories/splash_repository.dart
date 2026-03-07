import 'package:wisecare_agent/services/splash_service.dart';

/// Progress callback: 0.0 to 1.0.
typedef SplashProgressCallback = void Function(double progress);

/// Splash data orchestration. Only this layer talks to SplashService.
class SplashRepository {
  SplashRepository({SplashService? splashService})
      : _splashService = splashService ?? SplashService();

  final SplashService _splashService;

  Future<void> initialize({SplashProgressCallback? onProgress}) async {
    await _splashService.initialize(onProgress: onProgress);
  }
}
