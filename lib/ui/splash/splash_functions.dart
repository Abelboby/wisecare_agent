part of 'splash_screen.dart';

extension _SplashScreenFunctions on _SplashScreenState {
  void _checkRedirect(SplashProvider provider) {
    if (_hasRedirected || _redirectStarted || !_progressController.isCompleted || !provider.isInitialized) {
      return;
    }
    _redirectStarted = true;
    // When authenticated, load cached profile then fetch fresh data during splash
    // so home opens with profile ready and no second loading.
    (() async {
      final hasToken = await AuthStorageService.hasStoredAuthToken();
      if (!mounted) return;
      if (hasToken) {
        final profileProvider = context.read<ProfileProvider>();
        profileProvider.loadCachedProfile();
        await profileProvider.loadProfile(forceRefresh: true);
        if (!mounted || _hasRedirected) return;
      }
      _hasRedirected = true;
      if (mounted) RedirectionService.redirectAfterSplash(context);
    })();
  }
}
