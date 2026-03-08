part of '../login_screen.dart';

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.onSignIn,
    required this.onDemoLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback onSignIn;
  final VoidCallback onDemoLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: _LoginDimens.cardMaxWidth),
      decoration: BoxDecoration(
        color: Skin.color(Co.cardSurface),
        border: Border.all(color: Skin.color(Co.loginCardBorder)),
        borderRadius: BorderRadius.circular(_LoginDimens.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
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
          _LoginFormSection(
            emailController: emailController,
            passwordController: passwordController,
            emailFocusNode: emailFocusNode,
            passwordFocusNode: passwordFocusNode,
            onSignIn: onSignIn,
            onDemoLogin: onDemoLogin,
          ),
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
      padding: const EdgeInsets.fromLTRB(
        _LoginDimens.cardPaddingH,
        _LoginDimens.cardPaddingTop,
        _LoginDimens.cardPaddingH,
        _LoginDimens.gapAfterHeader,
      ),
      child: Column(
        children: [
          Container(
            width: _LoginDimens.headerIconSize,
            height: _LoginDimens.headerIconSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Skin.color(Co.loginLogoIconBg),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: SizedBox(
                width: _LoginDimens.headerIconInner,
                height: _LoginDimens.headerIconInner,
                child: Assets.icons.appIconPng.image(
                  width: _LoginDimens.headerIconInner,
                  height: _LoginDimens.headerIconInner,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: _LoginDimens.gapAfterHeader),
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
          const SizedBox(height: _LoginDimens.gapAfterTitle),
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
  const _LoginFormSection({
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.onSignIn,
    required this.onDemoLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback onSignIn;
  final VoidCallback onDemoLogin;

  @override
  State<_LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<_LoginFormSection> {
  bool _obscurePassword = true;

  void _refresh() => mounted ? setState(() {}) : null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _LoginDimens.cardPaddingH,
        _LoginDimens.gapSection,
        _LoginDimens.cardPaddingH,
        _LoginDimens.cardPaddingBottom,
      ),
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
          const SizedBox(height: _LoginDimens.gapAfterTitle),
          Text(
            'Please enter your credentials to access your dashboard and active cases.',
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: Skin.color(Co.loginInstruction),
            ),
          ),
          const SizedBox(height: _LoginDimens.gapSection),
          _LoginLabel(icon: Icons.email_outlined, label: 'Agent Mail ID'),
          const SizedBox(height: _LoginDimens.gapLabelField),
          TextField(
            controller: widget.emailController,
            focusNode: widget.emailFocusNode,
            onChanged: (value) => context.read<LoginProvider>().email = value,
            decoration: InputDecoration(
              hintText: 'e.g. agent@wisecare.com',
              hintStyle: GoogleFonts.lexend(
                fontSize: 16,
                height: 20 / 16,
                color: Skin.color(Co.loginPlaceholder),
              ),
              filled: true,
              fillColor: Skin.color(Co.loginInputBg),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_LoginDimens.inputRadius),
                borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_LoginDimens.inputRadius),
                borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: _LoginDimens.inputPaddingH,
                vertical: _LoginDimens.inputPaddingV,
              ),
            ),
            style: GoogleFonts.lexend(fontSize: 16, height: 20 / 16),
          ),
          const SizedBox(height: 20),
          _LoginLabel(icon: Icons.lock_outline, label: 'Password'),
          const SizedBox(height: _LoginDimens.gapLabelField),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                controller: widget.passwordController,
                focusNode: widget.passwordFocusNode,
                onChanged: (value) => context.read<LoginProvider>().password = value,
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
                    borderRadius: BorderRadius.circular(_LoginDimens.inputRadius),
                    borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_LoginDimens.inputRadius),
                    borderSide: BorderSide(color: Skin.color(Co.loginInputBorder)),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(
                    _LoginDimens.inputPaddingH,
                    _LoginDimens.inputPaddingV,
                    48,
                    _LoginDimens.inputPaddingV,
                  ),
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
                    size: _LoginDimens.passwordIconSize,
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
          if (context.read<LoginProvider>().errorMessage != null) ...[
            const SizedBox(height: _LoginDimens.gapLabelField),
            Text(
              context.read<LoginProvider>().errorMessage!,
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: Skin.color(Co.error),
              ),
            ),
          ],
          const SizedBox(height: _LoginDimens.gapBeforeButton),
          Container(
            height: _LoginDimens.buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_LoginDimens.buttonRadius),
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
              onPressed: context.read<LoginProvider>().isLoading ? null : widget.onSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Skin.color(Co.primary),
                foregroundColor: Skin.color(Co.onPrimary),
                disabledBackgroundColor: Skin.color(Co.primary).withValues(alpha: 0.6),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_LoginDimens.buttonRadius),
                ),
              ),
              child: context.read<LoginProvider>().isLoading
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
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: context.read<LoginProvider>().isLoading ? null : widget.onDemoLogin,
            style: OutlinedButton.styleFrom(
              foregroundColor: Skin.color(Co.primary),
              side: BorderSide(color: Skin.color(Co.primary)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_LoginDimens.buttonRadius),
              ),
            ),
            icon: const Icon(Icons.flash_on_outlined, size: 18),
            label: Text(
              'Demo login',
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
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
      padding: const EdgeInsets.all(_LoginDimens.gapSection),
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
            icon: Icon(
              Icons.person_outline,
              size: 12,
              color: Skin.color(Co.loginLabel),
            ),
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
