part of 'login_screen.dart';

extension _LoginScreenFunctions on _LoginScreenState {
  void _handleSignIn(BuildContext context) {
    final provider = context.read<LoginProvider>();
    provider.email = _emailController.text.trim();
    provider.password = _passwordController.text;
    provider.signIn();
  }

  void _handleDemoLogin(BuildContext context) {
    _emailController.text = _LoginDemoCredentials.email;
    _passwordController.text = _LoginDemoCredentials.password;
    final provider = context.read<LoginProvider>();
    provider.email = _LoginDemoCredentials.email;
    provider.password = _LoginDemoCredentials.password;
    provider.signIn();
  }
}
