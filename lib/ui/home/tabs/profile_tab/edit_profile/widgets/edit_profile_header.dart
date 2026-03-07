part of '../edit_profile_screen.dart';

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
