part of 'profile_tab_screen.dart';

extension _ProfileTabScreenFunctions on _ProfileTabScreenState {
  void _openEditProfile(BuildContext context) {
    Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }
}
