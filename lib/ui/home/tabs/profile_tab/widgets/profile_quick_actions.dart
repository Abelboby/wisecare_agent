part of '../profile_tab_screen.dart';

class _ProfileQuickActionsCard extends StatelessWidget {
  const _ProfileQuickActionsCard({
    required this.isOnline,
    required this.onToggleOnline,
    required this.onViewCertification,
    required this.onLogout,
    required this.isLoggingOut,
  });

  final bool isOnline;
  final VoidCallback onToggleOnline;
  final VoidCallback onViewCertification;
  final VoidCallback onLogout;
  final bool isLoggingOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Skin.color(Co.cardSurface),
        border: Border.all(color: Skin.color(Co.homeCardBorder)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileQuickActionRow(
            icon: Icons.power_settings_new_rounded,
            label: 'Go Offline',
            trailing: Switch(
              value: isOnline,
              onChanged: (_) => onToggleOnline(),
              activeTrackColor: Skin.color(Co.primary),
            ),
          ),
          Divider(height: 1, color: Skin.color(Co.loginInputBg)),
          _ProfileQuickActionRow(
            icon: Icons.workspace_premium_outlined,
            label: 'View Certification',
            trailing: Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: Skin.color(Co.loginIconMuted),
            ),
            onTap: onViewCertification,
          ),
          Divider(height: 1, color: Skin.color(Co.loginInputBg)),
          _ProfileQuickActionRow(
            icon: Icons.logout_rounded,
            label: 'Logout',
            iconColor: Skin.color(Co.profileLogoutRed),
            labelColor: Skin.color(Co.profileLogoutRed),
            onTap: isLoggingOut ? null : onLogout,
          ),
        ],
      ),
    );
  }
}

class _ProfileQuickActionRow extends StatelessWidget {
  const _ProfileQuickActionRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? Skin.color(Co.profileQuickActionIcon);
    final effectiveLabelColor = labelColor ?? Skin.color(Co.profileDetailValue);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 17.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: effectiveIconColor),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 24 / 16,
                      color: effectiveLabelColor,
                    ),
                  ),
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
