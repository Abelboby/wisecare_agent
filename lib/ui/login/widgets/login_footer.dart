part of '../login_screen.dart';

class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: _LoginDimens.footerTop),
      child: Column(
        children: [
          Opacity(
            opacity: 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Skin.color(Co.loginFooterDivider),
                  ),
                ),
                const SizedBox(width: _LoginDimens.footerDividerSpace),
                Text(
                  'WISECARE SYSTEMS',
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 15 / 10,
                    letterSpacing: 1,
                    color: Skin.color(Co.loginFooterBrand),
                  ),
                ),
                const SizedBox(width: _LoginDimens.footerDividerSpace),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Skin.color(Co.loginFooterDivider),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: _LoginDimens.footerDisclaimerTop),
          Text(
            'By logging in, you agree to the WiseCare Data Security Policy. Authorized personnel access only. All activities are monitored for compliance.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lexend(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 18 / 11,
              color: Skin.color(Co.loginFooterDisclaimer),
            ),
          ),
        ],
      ),
    );
  }
}
