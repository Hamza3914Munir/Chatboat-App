import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/core/theme/auth_colors.dart';
import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:facepix/features/auth/widgets/auth_inline_link_text.dart';
import 'package:facepix/features/auth/widgets/auth_resend_cooldown.dart';
import 'package:facepix/features/shell/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key, this.email});

  final String? email;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  static const _fallbackEmail = 'hello@facepix.ai';

  late String _email;
  late final AuthResendCooldown _cooldown;
  bool _resent = false;

  @override
  void initState() {
    super.initState();
    _email = widget.email ?? _fallbackEmail;
    _cooldown = AuthResendCooldown(onTick: () {
      if (mounted) setState(() {});
    });
    if (widget.email == null) _loadStoredEmail();
  }

  @override
  void dispose() {
    _cooldown.dispose();
    super.dispose();
  }

  Future<void> _loadStoredEmail() async {
    final stored = await AuthFlowPreferences.getSignupEmail();
    if (mounted) setState(() => _email = stored);
  }

  Future<void> _onVerified() async {
    await AuthFlowPreferences.setEmailVerified(true);
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
    );
  }

  /// Local-only for now: Firebase will send the real message. The point of
  /// wiring it up is that the button no longer does nothing at all.
  void _resend() {
    setState(() => _resent = true);
    _cooldown.start();
  }

  void _changeEmail() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const CreateAccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 64),
          child: Column(
            children: [
              Image.asset(
                'assets/auth/email_verification_illustration.png',
                width: 200,
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify your email',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 32 / 24,
                  letterSpacing: -0.6,
                  color: AuthColors.titleDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We sent a verification link to your email address. '
                'Please check your inbox and click the link to verify your account.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  color: AuthColors.termsText,
                ),
              ),
              const SizedBox(height: 24),
              EmailPill(email: _email),
              const SizedBox(height: 16),
              Semantics(
                liveRegion: _resent,
                child: Text(
                  _resent
                      ? 'Verification email sent again to $_email.'
                      : "Didn't receive the email? Check your spam folder or "
                            'try resending.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: AuthColors.subtitle,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GradientAuthButton(
                label: "I've Verified My Email",
                onPressed: _onVerified,
                borderRadius: 12,
                verticalPadding: 16,
                shadowColor: AuthColors.verificationButtonShadow,
              ),
              const SizedBox(height: 16),
              SecondaryOutlinedButton(
                label: _cooldown.isActive
                    ? 'Resend in ${_cooldown.secondsRemaining}s'
                    : 'Resend Verification Email',
                onPressed: _cooldown.isActive ? null : _resend,
              ),
              const SizedBox(height: 32),
              AuthInlineLinkText(
                spans: [
                  const AuthLinkSpan('Wrong email? '),
                  AuthLinkSpan.link('Change email address', _changeEmail),
                ],
                baseStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AuthColors.subtitle.withValues(alpha: 0.8),
                ),
                linkStyle: const TextStyle(color: AuthColors.link),
              ),
              const SizedBox(height: 16),
              FooterLinkRow(
                links: [
                  FooterLink(label: 'Help Center', onTap: () {}),
                  FooterLink(label: 'Contact Support', onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
