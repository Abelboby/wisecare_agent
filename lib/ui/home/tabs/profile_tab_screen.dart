import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/models/profile/profile_model.dart';
import 'package:wisecare_agent/provider/home_provider.dart';
import 'package:wisecare_agent/provider/profile_provider.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

/// Profile tab: Agent Profile header, stats, professional details, quick actions.
class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      body: Consumer2<ProfileProvider, HomeProvider>(
        builder: (context, profileProvider, homeProvider, _) {
          final profile = profileProvider.profile;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ProfileHeaderWithStats(
                  tasksCount: homeProvider.activeTasks.length,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _ProfileDetailsCard(profile: profile),
                    const SizedBox(height: 16),
                    _ProfileQuickActionsCard(
                      isOnline: homeProvider.isOnline,
                      onToggleOnline: () {
                        if (homeProvider.isOnline) {
                          homeProvider.setOffline();
                        } else {
                          homeProvider.setOnline();
                        }
                      },
                      onViewCertification: () {},
                      onLogout: () => profileProvider.signOut(),
                      isLoggingOut: profileProvider.isLoading,
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Wraps header and stats so stats paint on top and extend a little below the header.
class _ProfileHeaderWithStats extends StatelessWidget {
  const _ProfileHeaderWithStats({required this.tasksCount});

  final int tasksCount;

  /// How far the stats cards extend below the header (positive = into content area).
  static const double _statsOverlapBelow = 64;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const _ProfileHeader(),
        Positioned(
          left: 16,
          right: 16,
          bottom: -_statsOverlapBelow,
          child: _ProfileStatsSection(tasksCount: tasksCount),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

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
                    onPressed: () {},
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

class _ProfileStatsSection extends StatelessWidget {
  const _ProfileStatsSection({required this.tasksCount});

  final int tasksCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ProfileStatCard(
          label: 'Tasks',
          value: '$tasksCount',
        ),
        const SizedBox(width: 12),
        const _ProfileStatCard(
          label: 'Avg Resp',
          value: '4.2m',
        ),
        const SizedBox(width: 12),
        const _ProfileStatCard(
          label: 'Rating',
          value: '4.9',
          showStar: true,
        ),
      ],
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.label,
    required this.value,
    this.showStar = false,
  });

  final String label;
  final String value;
  final bool showStar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
                color: Skin.color(Co.homeStatsLabel),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: GoogleFonts.lexend(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 28 / 20,
                    color: Skin.color(Co.loginHeading),
                  ),
                ),
                if (showStar) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.star_rounded,
                    size: 20,
                    color: Skin.color(Co.profileStarRating),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({this.profile});

  final ProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    final agentId = profile != null
        ? 'AGT-${profile!.userId.length >= 5 ? profile!.userId.substring(profile!.userId.length - 5) : profile!.userId}'
        : 'AGT-99234';
    final serviceArea = profile?.city ?? 'Chennai South';
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PROFESSIONAL DETAILS',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 20 / 14,
              letterSpacing: 0.7,
              color: Skin.color(Co.profileSectionTitle),
            ),
          ),
          const SizedBox(height: 16),
          _ProfileDetailRow(
            icon: Icons.badge_outlined,
            label: 'Agent ID',
            value: agentId,
          ),
          const SizedBox(height: 16),
          _ProfileDetailRow(
            icon: Icons.location_on_outlined,
            label: 'Service Area',
            value: serviceArea,
          ),
          const SizedBox(height: 16),
          _ProfileDetailRow(
            icon: Icons.verified_user_outlined,
            label: 'Status',
            value: 'Verified',
            isVerifiedBadge: true,
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isVerifiedBadge = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isVerifiedBadge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Skin.color(Co.primary),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.lexend(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                  color: Skin.color(Co.loginLabel),
                ),
              ),
            ],
          ),
          if (isVerifiedBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Skin.color(Co.profileVerifiedBg),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                value,
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 20 / 14,
                  color: Skin.color(Co.profileVerifiedText),
                ),
              ),
            )
          else
            Text(
              value,
              style: GoogleFonts.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 24 / 16,
                color: Skin.color(Co.loginHeading),
              ),
            ),
        ],
      ),
    );
  }
}

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
    final defaultColor = Skin.color(Co.profileDetailValue);
    final effectiveIconColor = iconColor ?? Skin.color(Co.profileQuickActionIcon);
    final effectiveLabelColor = labelColor ?? defaultColor;
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
