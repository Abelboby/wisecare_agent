part of '../tasks_tab_screen.dart';

class _TasksHeader extends StatelessWidget {
  const _TasksHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_TasksTabDimens.headerPadding),
      decoration: BoxDecoration(
        color: Skin.color(Co.homeHeaderBg),
        border: Border(
          bottom: BorderSide(
            color: Skin.color(Co.homeHeaderBorder),
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                      final profile = profileProvider.profile;
                      final photoUrl = profile?.profilePhotoUrl;
                      return Container(
                        width: _TasksTabDimens.headerAvatarSize,
                        height: _TasksTabDimens.headerAvatarSize,
                        decoration: BoxDecoration(
                          color: Skin.color(Co.loginLogoIconBg),
                          border: Border.all(
                            color: Skin.color(Co.primary).withValues(alpha: 0.2),
                            width: _TasksTabDimens.headerAvatarBorder,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: photoUrl != null && photoUrl.isNotEmpty
                              ? Image.network(
                                  photoUrl,
                                  width: _TasksTabDimens.headerAvatarInner,
                                  height: _TasksTabDimens.headerAvatarInner,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _headerPlaceholderIcon(),
                                )
                              : _headerPlaceholderIcon(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<ProfileProvider>(
                        builder: (context, profileProvider, _) {
                          final name = profileProvider.profile?.name ?? 'Agent';
                          return Text(
                            name,
                            style: GoogleFonts.lexend(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 22 / 18,
                              color: Skin.color(Co.loginHeading),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: _TasksTabDimens.headerNameStatusGap),
                      Row(
                        children: [
                          Container(
                            width: _TasksTabDimens.headerStatusDot,
                            height: _TasksTabDimens.headerStatusDot,
                            decoration: BoxDecoration(
                              color: Skin.color(Co.homeStatusOnline),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ONLINE',
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              letterSpacing: 0.6,
                              color: Skin.color(Co.loginSubtitle),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.read<HomeProvider>().setOffline();
                  },
                  borderRadius: BorderRadius.circular(9999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Skin.color(Co.primary).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: Skin.color(Co.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Go Offline',
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 20 / 14,
                            color: Skin.color(Co.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerPlaceholderIcon() {
    return Icon(
      Icons.person_rounded,
      size: _TasksTabDimens.headerAvatarInner,
      color: Skin.color(Co.primary),
    );
  }
}
