import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/provider/login_provider.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

/// Login screen: Agent ID, password, and sign-in for field representatives.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  void _refresh() => mounted ? setState(() {}) : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      body: SafeArea(
        child: Consumer<LoginProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LoginCard(provider: provider),
                      const SizedBox(height: 32),
                      const _LoginFooter(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.provider});

  final LoginProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 440),
      decoration: BoxDecoration(
        color: Skin.color(Co.cardSurface),
        border: Border.all(color: Skin.color(Co.loginCardBorder)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 50,
            offset: const Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _LoginCardHeader(),
          _LoginFormSection(provider: provider),
          const _LoginContactSection(),
        ],
      ),
    );
  }
}

class _LoginCardHeader extends StatelessWidget {
  const _LoginCardHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Skin.color(Co.loginLogoIconBg),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield,
              size: 30,
              color: Skin.color(Co.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'WiseAgent',
            textAlign: TextAlign.center,
            style: GoogleFonts.lexend(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 32 / 24,
              letterSpacing: -0.6,
              color: Skin.color(Co.loginHeading),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Secure Portal for Field Representatives',
            textAlign: TextAlign.center,
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: Skin.color(Co.loginSubtitle),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginFormSection extends StatefulWidget {
  const _LoginFormSection({required this.provider});

  final LoginProvider provider;

  @override
  State<_LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<_LoginFormSection> {
  bool _obscurePassword = true;

  void _refresh() => mounted ? setState(() {}) : null;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome Back',
            style: GoogleFonts.lexend(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 30 / 24,
              color: Skin.color(Co.loginHeading),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please enter your credentials to access your dashboard and active cases.',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: Skin.color(Co.loginInstruction),
            ),
          ),
          const SizedBox(height: 24),
          _LoginLabel(icon: Icons.badge_outlined, label: 'Agent ID'),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) => provider.email = value,
            decoration: InputDecoration(
              hintText: 'e.g. AGT-99234',
              hintStyle: GoogleFonts.lexend(
                fontSize: 16,
                height: 20 / 16,
                color: Skin.color(Co.loginPlaceholder),
              ),
              filled: true,
              fillColor: Skin.color(Co.loginInputBg),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            style: GoogleFonts.lexend(fontSize: 16, height: 20 / 16),
          ),
          const SizedBox(height: 20),
          _LoginLabel(icon: Icons.lock_outline, label: 'Password'),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                onChanged: (value) => provider.password = value,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: GoogleFonts.lexend(
                    fontSize: 16,
                    height: 20 / 16,
                    color: Skin.color(Co.loginPlaceholder),
                  ),
                  filled: true,
                  fillColor: Skin.color(Co.loginInputBg),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 13, 48, 13),
                ),
                style: GoogleFonts.lexend(fontSize: 16, height: 20 / 16),
              ),
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 22,
                    color: Skin.color(Co.loginIconMuted),
                  ),
                  onPressed: () {
                    _obscurePassword = !_obscurePassword;
                    _refresh();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Forgot Credentials?',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  color: Skin.color(Co.primary),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          if (provider.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              provider.errorMessage!,
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: Skin.color(Co.error),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Skin.color(Co.loginButtonShadow),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                  spreadRadius: -3,
                ),
                BoxShadow(
                  color: Skin.color(Co.loginButtonShadow),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () => provider.signIn(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Skin.color(Co.primary),
                foregroundColor: Skin.color(Co.onPrimary),
                disabledBackgroundColor: Skin.color(Co.primary).withOpacity(0.6),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login to Dashboard',
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 24 / 16,
                            color: Skin.color(Co.onPrimary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Skin.color(Co.onPrimary),
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

class _LoginLabel extends StatelessWidget {
  const _LoginLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 10, color: Skin.color(Co.loginLabel)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 20 / 14,
            color: Skin.color(Co.loginLabel),
          ),
        ),
      ],
    );
  }
}

class _LoginContactSection extends StatelessWidget {
  const _LoginContactSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Skin.color(Co.loginInputBg),
        border: Border(
          top: BorderSide(color: Skin.color(Co.loginContactBorder)),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Having trouble signing in?',
            textAlign: TextAlign.center,
            style: GoogleFonts.lexend(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              color: Skin.color(Co.loginSubtitle),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.person_outline, size: 12, color: Skin.color(Co.loginLabel)),
            label: Text(
              'Contact Admin for Access',
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
                color: Skin.color(Co.loginLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
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
                const SizedBox(width: 16),
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
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Skin.color(Co.loginFooterDivider),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
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
