part of 'splash_screen.dart';

extension _SplashScreenFunctions on _SplashScreenState {
  void _checkRedirect(SplashProvider provider) {
    if (_hasRedirected || !_progressController.isCompleted || !provider.isInitialized) {
      return;
    }
    _hasRedirected = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) RedirectionService.redirectAfterSplash(context);
    });
  }
}
