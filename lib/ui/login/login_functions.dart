part of 'login_screen.dart';

extension _LoginScreenFunctions on _LoginScreenState {
  void _handleSignIn(BuildContext context) {
    final provider = context.read<LoginProvider>();
    provider.email = _emailController.text.trim();
    provider.password = _passwordController.text;
    provider.signIn();
  }
}
