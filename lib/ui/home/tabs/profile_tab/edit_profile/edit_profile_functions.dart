part of 'edit_profile_screen.dart';

extension _EditProfileScreenFunctions on _EditProfileScreenState {
  static DateTime? parseDateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      return DateTime.parse(value.trim());
    } catch (_) {
      return null;
    }
  }

  static String formatDateOfBirth(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _handleSave() async {
    final profileProvider = context.read<ProfileProvider>();
    final name = _nameController.text.trim();
    final dateOfBirth = _selectedDateOfBirth != null ? formatDateOfBirth(_selectedDateOfBirth!) : '';
    final city = _cityController.text.trim();
    final cityImageUrl = _cityImageUrlController.text.trim();

    final request = UpdateProfileRequest(
      name: name.isNotEmpty ? name : null,
      dateOfBirth: dateOfBirth.isNotEmpty ? dateOfBirth : null,
      city: city.isNotEmpty ? city : null,
      cityImageUrl: cityImageUrl.isNotEmpty ? cityImageUrl : null,
    );

    if (request.toJson().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enter at least one field to update.'),
          ),
        );
      }
      return;
    }

    try {
      await profileProvider.updateProfileDetails(request);
      if (!mounted) return;
      if (profileProvider.errorMessage != null && profileProvider.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(profileProvider.errorMessage!)),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: ${e.toString()}')),
        );
      }
    }
  }
}
