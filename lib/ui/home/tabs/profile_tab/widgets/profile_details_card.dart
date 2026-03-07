part of '../profile_tab_screen.dart';

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
