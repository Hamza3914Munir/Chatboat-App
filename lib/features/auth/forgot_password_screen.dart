import 'dart:async';

import 'package:facepix/core/theme/auth_colors.dart';
import 'package:facepix/core/validation/auth_validators.dart';
import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:facepix/features/auth/login_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:facepix/features/auth/widgets/auth_inline_link_text.dart';
import 'package:facepix/features/auth/widgets/auth_resend_cooldown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  late final AuthResendCooldown _cooldown;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _cooldown = AuthResendCooldown(onTick: () => setState(() {}));
  }

  @override
  void dispose() {
    _cooldown.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _emailFocus.requestFocus();
      return;
    }

    // No mail is actually sent yet — the reset email is Firebase's job. Until
    // then this gives the user the confirmation the screen previously withheld
    // entirely, and stops them hammering a button that looked inert.
    FocusScope.of(context).unfocus();
    setState(() => _sent = true);
    _cooldown.start();
  }

  void _backToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  void _goToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const CreateAccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final promptStyle = GoogleFonts.inter(
      fontSize: 15,
      height: 22.5 / 15,
      color: AuthColors.subtitle,
    );
    const linkStyle = TextStyle(color: AuthColors.link);

    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 64),
              child: Column(
                children: [
                  SizedBox(
                    width: 204,
                    height: 144,
                    child: Image.asset(
                      'assets/auth/forgot_password_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 36 / 28,
                      color: AuthColors.title,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(
                      "Enter the email associated with your account and we'll "
                      'send you a reset link.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                        color: AuthColors.subtitle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    leadingIconAsset: 'assets/auth/icon_email.svg',
                    controller: _emailController,
                    focusNode: _emailFocus,
                    validator: AuthValidators.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.username],
                    onSubmitted: (_) => _sendResetLink(),
                    borderColor: AuthColors.forgotFieldBorder,
                  ),
                  if (_sent) ...[
                    const SizedBox(height: 16),
                    _ResetLinkSentNotice(email: _emailController.text.trim()),
                  ],
                  const SizedBox(height: 24),
                  GradientAuthButton(
                    label: _cooldown.isActive
                        ? 'Resend in ${_cooldown.secondsRemaining}s'
                        : (_sent ? 'Resend Reset Link' : 'Send Reset Link'),
                    onPressed: _cooldown.isActive ? null : _sendResetLink,
                    gradient: AuthColors.forgotButtonGradient,
                    borderRadius: 16,
                    verticalPadding: 16,
                    fontSize: 16,
                    trailingIconAsset: _cooldown.isActive
                        ? null
                        : 'assets/auth/icon_arrow_right_forgot.svg',
                  ),
                  const SizedBox(height: 32),
                  AuthInlineLinkText(
                    spans: [
                      const AuthLinkSpan('Remember your password? '),
                      AuthLinkSpan.link('Back to Login', _backToLogin),
                    ],
                    baseStyle: promptStyle,
                    linkStyle: linkStyle,
                  ),
                  const SizedBox(height: 16),
                  AuthInlineLinkText(
                    spans: [
                      const AuthLinkSpan("Don't have an account? "),
                      AuthLinkSpan.link('Sign Up', _goToSignUp),
                    ],
                    baseStyle: promptStyle,
                    linkStyle: linkStyle,
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

class _ResetLinkSentNotice extends StatelessWidget {
  const _ResetLinkSentNotice({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AuthColors.dataSharingHistoryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AuthColors.dataSharingHistoryBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'If an account exists for $email, a reset link is on its way. '
            'Check your spam folder if it does not arrive.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 18 / 13,
              color: AuthColors.termsText,
            ),
          ),
        ),
      ),
    );
  }
}
