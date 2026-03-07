part of '../edit_profile_screen.dart';

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
