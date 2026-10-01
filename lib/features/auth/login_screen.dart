import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/core/preferences/registration_preferences.dart';
import 'package:facepix/core/theme/auth_colors.dart';
import 'package:facepix/core/validation/auth_validators.dart';
import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:facepix/features/auth/forgot_password_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:facepix/features/auth/widgets/auth_inline_link_text.dart';
import 'package:facepix/features/shell/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _passwordVisible = false;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      if (AuthValidators.email(_emailController.text) != null) {
        _emailFocus.requestFocus();
      } else {
        _passwordFocus.requestFocus();
      }
      return;
    }

    setState(() => _submitting = true);

    // Persist the session before navigating. Without this the app reached the
    // shell but AppBootstrap still saw an unregistered, unverified user on the
    // next launch and sent them back to Create Account.
    await AuthFlowPreferences.setSignupEmail(_emailController.text.trim());
    await RegistrationPreferences.setCompleted(true);
    await AuthFlowPreferences.setEmailVerified(true);
    if (!mounted) return;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
    );
  }

  void _goToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  void _goToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const CreateAccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    width: 120,
                    height: 84,
                    child: Image.asset(
                      'assets/auth/login_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 36 / 28,
                      color: AuthColors.loginTitle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log in to continue creating with AI.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 24 / 16,
                      color: AuthColors.loginSubtitle,
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
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    label: 'Password',
                    hint: '••••••••',
                    leadingIconAsset: 'assets/auth/icon_lock.svg',
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    validator: AuthValidators.loginPassword,
                    obscureText: !_passwordVisible,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    onSubmitted: (_) => _logIn(),
                    suffix: PasswordVisibilityToggle(
                      visible: _passwordVisible,
                      onToggle: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: _goToForgotPassword,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: kMinInlineTapTarget,
                        ),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AuthColors.loginLink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientAuthButton(
                    label: 'Log In',
                    onPressed: _logIn,
                    busy: _submitting,
                    gradient: AuthColors.loginButtonGradient,
                    borderRadius: 12,
                    verticalPadding: 16,
                    fontSize: 16,
                    trailingIconAsset: 'assets/auth/icon_arrow_right.svg',
                  ),
                  const SizedBox(height: 32),
                  AuthInlineLinkText(
                    spans: [
                      const AuthLinkSpan("Don't have an account? "),
                      AuthLinkSpan.link('Sign Up', _goToSignUp),
                    ],
                    baseStyle: GoogleFonts.inter(
                      fontSize: 15,
                      height: 22.5 / 15,
                      color: AuthColors.loginSubtitle,
                    ),
                    linkStyle: const TextStyle(color: AuthColors.link),
                  ),
                  const SizedBox(height: 24),
                  // Wrap, not Row: the two pills need ~317pt with Inter at the
                  // default text size, which leaves barely 25pt of slack on a
                  // 390pt phone and overflows outright on a 360pt one or at
                  // any accessibility text scale.
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FooterPillButton(
                        label: 'Privacy Policy',
                        onPressed: () {},
                      ),
                      FooterPillButton(
                        label: 'Terms of Service',
                        onPressed: () {},
                      ),
                    ],
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
