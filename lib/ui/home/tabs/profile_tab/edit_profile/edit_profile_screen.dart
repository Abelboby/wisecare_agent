import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/models/profile/profile_model.dart';
import 'package:wisecare_agent/provider/profile_provider.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'edit_profile_variables.dart';
part 'edit_profile_functions.dart';
part 'widgets/edit_profile_header.dart';
part 'widgets/edit_profile_fields.dart';

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
      _selectedDateOfBirth = _EditProfileScreenFunctions.parseDateOfBirth(profile.dateOfBirth);
      _cityController.text = profile.city ?? '';
      _cityImageUrlController.text = profile.cityImageUrl ?? '';
    });
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
                avatarSize: _EditProfileDimens.avatarSize,
                avatarBorderWidth: _EditProfileDimens.avatarBorderWidth,
                avatarEditButtonSize: _EditProfileDimens.avatarEditButtonSize,
                avatarEditIconSize: _EditProfileDimens.avatarEditIconSize,
                headerBorderRadius: _EditProfileDimens.headerBorderRadius,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(_EditProfileDimens.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _EditProfileField(
                        label: 'Name',
                        controller: _nameController,
                        hint: 'Full name',
                        inputRadius: _EditProfileDimens.inputRadius,
                      ),
                      const SizedBox(height: 16),
                      _EditProfileDateOfBirthField(
                        label: 'Date of birth',
                        selectedDate: _selectedDateOfBirth,
                        hint: 'Tap to select date',
                        inputRadius: _EditProfileDimens.inputRadius,
                        onTap: _openDateOfBirthPicker,
                      ),
                      const SizedBox(height: 16),
                      _EditProfileField(
                        label: 'City',
                        controller: _cityController,
                        hint: 'City name',
                        inputRadius: _EditProfileDimens.inputRadius,
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
                padding: const EdgeInsets.fromLTRB(_EditProfileDimens.screenPadding, 16, _EditProfileDimens.screenPadding, 24),
                child: FilledButton(
                  onPressed: isLoading ? null : _handleSave,
                  style: FilledButton.styleFrom(
                    backgroundColor: Skin.color(Co.primary),
                    foregroundColor: Skin.color(Co.onPrimary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_EditProfileDimens.inputRadius),
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
