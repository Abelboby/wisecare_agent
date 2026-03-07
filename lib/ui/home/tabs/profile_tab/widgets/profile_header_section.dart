part of '../profile_tab_screen.dart';

abstract final class _ProfileHeaderDimens {
  static const double statsOverlapBelow = 64;
}

/// Wraps header and stats so stats paint on top and extend a little below the header.
class _ProfileHeaderWithStats extends StatelessWidget {
  const _ProfileHeaderWithStats({
    required this.tasksCount,
    required this.onEditProfile,
  });

  final int tasksCount;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _ProfileHeader(onEditProfile: onEditProfile),
        Positioned(
          left: 16,
          right: 16,
          bottom: -_ProfileHeaderDimens.statsOverlapBelow,
          child: _ProfileStatsSection(tasksCount: tasksCount),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onEditProfile});

  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top + 24;
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final profile = profileProvider.profile;
        final name = profile?.name ?? 'Agent';
        final role = profile?.role ?? 'RESPONDER';
        final photoUrl = profile?.profilePhotoUrl;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24, topPadding, 24, 24),
          decoration: BoxDecoration(
            color: Skin.color(Co.gradientTop),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 10),
                spreadRadius: -3,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agent Profile',
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 28 / 20,
                      color: Skin.color(Co.onPrimary),
                    ),
                  ),
                  _ProfileHeaderButton(
                    icon: Icons.settings_rounded,
                    onPressed: onEditProfile,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Skin.color(Co.primary),
                        width: 4,
                      ),
                    ),
                    child: ClipOval(
                      child: photoUrl != null && photoUrl.isNotEmpty
                          ? Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              width: 128,
                              height: 128,
                              errorBuilder: (_, __, ___) => _ProfileAvatarPlaceholder(name: name),
                            )
                          : _ProfileAvatarPlaceholder(name: name),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Skin.color(Co.homeStatusOnline),
                        border: Border.all(
                          color: Skin.color(Co.profileOnlineBadgeBorder),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 32 / 24,
                  color: Skin.color(Co.onPrimary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  letterSpacing: 0.35,
                  color: Skin.color(Co.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileHeaderButton extends StatelessWidget {
  const _ProfileHeaderButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Skin.color(Co.profileHeaderButtonBg),
      borderRadius: BorderRadius.circular(9999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9999),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            size: icon == Icons.settings_rounded ? 20 : 16,
            color: Skin.color(Co.onPrimary),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatarPlaceholder extends StatelessWidget {
  const _ProfileAvatarPlaceholder({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    return Container(
      color: Skin.color(Co.loginLogoIconBg),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.lexend(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: Skin.color(Co.primary),
        ),
      ),
    );
  }

  static String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (name.isNotEmpty) return name[0].toUpperCase();
    return '?';
  }
}
