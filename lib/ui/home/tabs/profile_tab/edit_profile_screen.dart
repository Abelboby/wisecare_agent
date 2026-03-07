import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/models/profile/profile_model.dart';
import 'package:wisecare_agent/provider/profile_provider.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

/// Screen to edit agent profile fields supported by PUT /users/me.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _cityImageUrlController = TextEditingController();

  DateTime? _selectedDateOfBirth;

  static const double _inputRadius = 12;
  static const double _screenPadding = 16;
  static const double _headerBorderRadius = 48;
  static const double _avatarSize = 120;
  static const double _avatarBorderWidth = 4;
  static const double _avatarEditButtonSize = 36;
  static const double _avatarEditIconSize = 18;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fillFromProfile());
  }

  void _fillFromProfile() {
    if (!mounted) return;
    final profile = context.read<ProfileProvider>().profile;
    if (profile == null) return;
    setState(() {
      _nameController.text = profile.name;
      _selectedDateOfBirth = _parseDateOfBirth(profile.dateOfBirth);
      _cityController.text = profile.city ?? '';
      _cityImageUrlController.text = profile.cityImageUrl ?? '';
    });
  }

  static DateTime? _parseDateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      return DateTime.parse(value.trim());
    } catch (_) {
      return null;
    }
  }

  static String _formatDateOfBirth(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _openDateOfBirthPicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDateOfBirth = picked);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _cityImageUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final profileProvider = context.read<ProfileProvider>();
    final name = _nameController.text.trim();
    final dateOfBirth = _selectedDateOfBirth != null ? _formatDateOfBirth(_selectedDateOfBirth!) : '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      appBar: AppBar(
        backgroundColor: Skin.color(Co.gradientTop),
        foregroundColor: Skin.color(Co.onPrimary),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.lexend(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Skin.color(Co.onPrimary),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          final isLoading = profileProvider.isLoading;
          final profile = profileProvider.profile;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EditProfileHeader(
                imageUrl: profile?.profilePhotoUrl,
                isUploadingPhoto: profileProvider.isUploadingPhoto,
                onEditPhotoTap: profileProvider.uploadProfilePhoto,
                avatarSize: _avatarSize,
                avatarBorderWidth: _avatarBorderWidth,
                avatarEditButtonSize: _avatarEditButtonSize,
                avatarEditIconSize: _avatarEditIconSize,
                headerBorderRadius: _headerBorderRadius,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(_screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _EditProfileField(
                        label: 'Name',
                        controller: _nameController,
                        hint: 'Full name',
                        inputRadius: _inputRadius,
                      ),
                      const SizedBox(height: 16),
                      _EditProfileDateOfBirthField(
                        label: 'Date of birth',
                        selectedDate: _selectedDateOfBirth,
                        hint: 'Tap to select date',
                        inputRadius: _inputRadius,
                        onTap: _openDateOfBirthPicker,
                      ),
                      const SizedBox(height: 16),
                      _EditProfileField(
                        label: 'City',
                        controller: _cityController,
                        hint: 'City name',
                        inputRadius: _inputRadius,
                      ),
                      const SizedBox(height: 16),
                      if (profileProvider.errorMessage != null && profileProvider.errorMessage!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          profileProvider.errorMessage!,
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            color: Skin.color(Co.error),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(_screenPadding, 16, _screenPadding, 24),
                child: FilledButton(
                  onPressed: isLoading ? null : _handleSave,
                  style: FilledButton.styleFrom(
                    backgroundColor: Skin.color(Co.primary),
                    foregroundColor: Skin.color(Co.onPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_inputRadius),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Save changes',
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EditProfileHeader extends StatelessWidget {
  const _EditProfileHeader({
    required this.imageUrl,
    required this.isUploadingPhoto,
    required this.onEditPhotoTap,
    required this.avatarSize,
    required this.avatarBorderWidth,
    required this.avatarEditButtonSize,
    required this.avatarEditIconSize,
    required this.headerBorderRadius,
  });

  final String? imageUrl;
  final bool isUploadingPhoto;
  final VoidCallback? onEditPhotoTap;
  final double avatarSize;
  final double avatarBorderWidth;
  final double avatarEditButtonSize;
  final double avatarEditIconSize;
  final double headerBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Skin.color(Co.gradientTop),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(headerBorderRadius),
          bottomRight: Radius.circular(headerBorderRadius),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Center(
            child: SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: Stack(
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Skin.color(Co.surface),
                      border: Border.all(
                        color: Skin.color(Co.primary).withValues(alpha: 0.5),
                        width: avatarBorderWidth,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 25,
                          offset: Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 10,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: imageUrl != null && imageUrl!.isNotEmpty
                          ? Image.network(
                              imageUrl!,
                              width: avatarSize,
                              height: avatarSize,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const _EditProfileAvatarFallback(),
                            )
                          : const _EditProfileAvatarFallback(),
                    ),
                  ),
                  if (isUploadingPhoto)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black26,
                        ),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Skin.color(Co.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  if (onEditPhotoTap != null)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: onEditPhotoTap,
                        child: Container(
                          width: avatarEditButtonSize,
                          height: avatarEditButtonSize,
                          decoration: BoxDecoration(
                            color: Skin.color(Co.primary),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Skin.color(Co.loginHeader),
                              width: 3,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            color: Skin.color(Co.onPrimary),
                            size: avatarEditIconSize,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditProfileAvatarFallback extends StatelessWidget {
  const _EditProfileAvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Skin.color(Co.surface),
      child: Icon(
        Icons.person_rounded,
        size: 64,
        color: Skin.color(Co.textMuted),
      ),
    );
  }
}

class _EditProfileField extends StatelessWidget {
  const _EditProfileField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.inputRadius,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final double inputRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Skin.color(Co.loginLabel),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.lexend(
              fontSize: 16,
              height: 20 / 16,
              color: Skin.color(Co.loginPlaceholder),
            ),
            filled: true,
            fillColor: Skin.color(Co.loginInputBg),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(inputRadius),
              borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(inputRadius),
              borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: GoogleFonts.lexend(fontSize: 16, height: 20 / 16),
        ),
      ],
    );
  }
}

class _EditProfileDateOfBirthField extends StatelessWidget {
  const _EditProfileDateOfBirthField({
    required this.label,
    required this.selectedDate,
    required this.hint,
    required this.inputRadius,
    required this.onTap,
  });

  final String label;
  final DateTime? selectedDate;
  final String hint;
  final double inputRadius;
  final VoidCallback onTap;

  static String _formatDisplay(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDate != null ? _formatDisplay(selectedDate!) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Skin.color(Co.loginLabel),
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Skin.color(Co.loginInputBg),
          borderRadius: BorderRadius.circular(inputRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(inputRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(inputRadius),
                border: Border.all(color: Skin.color(Co.loginInputBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayText ?? hint,
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        height: 20 / 16,
                        color: displayText != null ? Skin.color(Co.onSurface) : Skin.color(Co.loginPlaceholder),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: Skin.color(Co.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
