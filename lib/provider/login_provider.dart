import 'package:flutter/foundation.dart';

import 'package:wisecare_agent/navigation/app_navigator.dart';
import 'package:wisecare_agent/navigation/routes.dart';
import 'package:wisecare_agent/repositories/login_repository.dart';

/// Login screen state. Calls repository only.
class LoginProvider extends ChangeNotifier {
  LoginProvider({LoginRepository? repository}) : _repository = repository ?? LoginRepository();

  final LoginRepository _repository;

  String _email = '';
  String get email => _email;
  set email(String value) {
    if (_email != value) {
      _email = value;
    }
  }

  String _password = '';
  String get password => _password;
  set password(String value) {
    if (_password != value) {
      _password = value;
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    if (_isLoading) return;
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();
    try {
      final model = await _repository.signIn(_email, _password);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      final step = model.onboardingStep;
      if (step == 'COMPLETE') {
        AppNavigator.navigate(AppRoutes.home);
      } else {
        AppNavigator.navigate(AppRoutes.home);
      }
    } catch (e) {
      _errorMessage = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
