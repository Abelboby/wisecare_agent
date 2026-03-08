part of '../task_details_screen.dart';

/// Full-width primary action button shown at the bottom of the task detail screen.
/// Label and action change based on the current task status.
class _TaskActionButton extends StatelessWidget {
  const _TaskActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Skin.color(Co.primary),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Skin.color(Co.primary).withValues(alpha: 0.30),
                  blurRadius: 25,
                  offset: const Offset(0, 20),
                ),
                BoxShadow(
                  color: Skin.color(Co.primary).withValues(alpha: 0.30),
                  blurRadius: 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 28 / 18,
                color: Skin.color(Co.onPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
