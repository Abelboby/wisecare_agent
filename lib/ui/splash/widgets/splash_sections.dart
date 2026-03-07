part of '../splash_screen.dart';

class _DecorativeBlurs extends StatelessWidget {
  const _DecorativeBlurs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -20,
          top: -88,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                color: Skin.color(Co.splashBlurOrangeTop),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          left: -20,
          bottom: -88,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                color: Skin.color(Co.splashBlurOrangeBottom),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 160,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: Skin.color(Co.splashLogoRingFill),
              border: Border.all(
                color: Skin.color(Co.splashLogoRingBorder),
                width: 1,
              ),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Center(
                  child: Assets.icons.appIconSvg.svg(width: 128, height: 128),
                ),
              ),
            ),
          ),
          Positioned(
            right: -16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Skin.color(Co.primary),
                border: Border.all(
                  color: Skin.color(Co.gradientTop),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: [
                  BoxShadow(
                    color: Skin.color(Co.splashBadgeShadow),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield,
                    size: 12,
                    color: Skin.color(Co.onPrimary),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'AGENT',
                    style: GoogleFonts.lexend(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Skin.color(Co.onPrimary),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'WiseAgent',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 40 / 36,
        letterSpacing: -0.9,
        color: Skin.color(Co.onPrimary),
      ),
    );
  }
}

class _SplashSubtitle extends StatelessWidget {
  const _SplashSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'SERVICE & RESPONSE TEAM',
      textAlign: TextAlign.center,
      style: GoogleFonts.lexend(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 2.8,
        color: Skin.color(Co.splashSubtitle),
      ),
    );
  }
}

class _SplashFooter extends StatelessWidget {
  const _SplashFooter({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SYSTEM BOOTING',
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
                letterSpacing: 1.2,
                color: Skin.color(Co.splashLoadingLabel),
              ),
            ),
            Text(
              '$percent%',
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 16 / 12,
                color: Skin.color(Co.splashLoadingPercent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: SizedBox(
            height: 4,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 4,
                  color: Skin.color(Co.splashProgressTrack),
                ),
                SplashProgressFill(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Skin.color(Co.primary),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Skin.color(Co.primary),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Secure Professional Access',
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                height: 16 / 12,
                color: Skin.color(Co.splashStatusText),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
