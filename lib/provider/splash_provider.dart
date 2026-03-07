import 'package:flutter/foundation.dart';

import 'package:wisecare_agent/repositories/splash_repository.dart';

/// Splash screen state. Calls repository only.
class SplashProvider extends ChangeNotifier {
  SplashProvider({SplashRepository? repository})
      : _repository = repository ?? SplashRepository();

  final SplashRepository _repository;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  double _progress = 0.0;
  double get progress => _progress;

  String? _error;
  String? get error => _error;

  void updateProgress(double value) {
    final clamped = value.clamp(0.0, 1.0);
    if (_progress != clamped) {
      _progress = clamped;
      notifyListeners();
    }
  }

  Future<void> loadInitialData() async {
    if (_isInitialized) return;
    try {
      updateProgress(0.0);
      await _repository.initialize(onProgress: updateProgress);
      _isInitialized = true;
      _error = null;
      updateProgress(1.0);
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }
}
