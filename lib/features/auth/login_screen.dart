import 'package:facepix/core/theme/auth_colors.dart';
import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:facepix/features/auth/forgot_password_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:facepix/features/shell/app_shell.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
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
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Password',
                hint: '••••••••',
                leadingIconAsset: 'assets/auth/icon_lock.svg',
                controller: _passwordController,
                obscureText: !_passwordVisible,
                suffix: PasswordVisibilityToggle(
                  visible: _passwordVisible,
                  onToggle: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _goToForgotPassword,
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
              const SizedBox(height: 24),
              GradientAuthButton(
                label: 'Log In',
                onPressed: _logIn,
                gradient: AuthColors.loginButtonGradient,
                borderRadius: 12,
                verticalPadding: 16,
                fontSize: 16,
                trailingIconAsset: 'assets/auth/icon_arrow_right.svg',
              ),
              const SizedBox(height: 32),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    height: 22.5 / 15,
                    color: AuthColors.loginSubtitle,
                  ),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(color: AuthColors.link),
                      recognizer: TapGestureRecognizer()..onTap = _goToSignUp,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FooterPillButton(label: 'Privacy Policy', onPressed: () {}),
                  const SizedBox(width: 12),
                  FooterPillButton(label: 'Terms of Service', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
