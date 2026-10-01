import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/core/preferences/registration_preferences.dart';
import 'package:facepix/core/theme/auth_colors.dart';
import 'package:facepix/features/auth/email_verification_screen.dart';
import 'package:facepix/features/auth/login_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _termsAccepted = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _completeRegistration() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      await AuthFlowPreferences.setSignupEmail(email);
    }
    await RegistrationPreferences.setCompleted(true);
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            EmailVerificationScreen(email: email.isNotEmpty ? email : null),
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 64),
          child: Column(
            children: [
              SizedBox(
                width: 204,
                height: 144,
                child: Image.asset(
                  'assets/auth/signup_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your account',
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
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  'Start creating amazing photos and\nvideos with AI.',
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
                label: 'Full Name',
                hint: 'Enter your full name',
                leadingIconAsset: 'assets/auth/icon_user.svg',
                controller: _fullNameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Email',
                hint: 'Enter your email',
                leadingIconAsset: 'assets/auth/icon_email.svg',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Password',
                hint: '••••••••',
                leadingIconAsset: 'assets/auth/icon_lock.svg',
                controller: _passwordController,
                obscureText: !_passwordVisible,
                helperText: 'Use at least 8 characters.',
                suffix: PasswordVisibilityToggle(
                  visible: _passwordVisible,
                  onToggle: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Confirm Password',
                hint: '••••••••',
                leadingIconAsset: 'assets/auth/icon_lock.svg',
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                suffix: PasswordVisibilityToggle(
                  visible: _confirmPasswordVisible,
                  onToggle: () => setState(
                    () => _confirmPasswordVisible = !_confirmPasswordVisible,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _TermsCheckboxRow(
                value: _termsAccepted,
                onChanged: (value) =>
                    setState(() => _termsAccepted = value ?? false),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: _termsAccepted ? 1 : 0.55,
                child: GradientAuthButton(
                  label: 'Create Account',
                  onPressed: _termsAccepted ? _completeRegistration : () {},
                ),
              ),
              const SizedBox(height: 31),
              _LoginPrompt(onLogIn: _goToLogin),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsCheckboxRow extends StatelessWidget {
  const _TermsCheckboxRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AuthColors.link,
            side: const BorderSide(color: AuthColors.fieldBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 17.5 / 14,
                color: AuthColors.termsText,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(color: AuthColors.link),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(color: AuthColors.link),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onLogIn});

  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 15,
          height: 22.5 / 15,
          color: AuthColors.subtitle,
        ),
        children: [
          const TextSpan(text: 'Already have an account? '),
          TextSpan(
            text: 'Log In',
            style: const TextStyle(color: AuthColors.link),
            recognizer: TapGestureRecognizer()..onTap = onLogIn,
          ),
        ],
      ),
    );
  }
}
