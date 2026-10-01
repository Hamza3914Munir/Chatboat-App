import 'package:facepix/core/theme/auth_colors.dart';
import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:facepix/features/auth/login_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
                  "Enter the email associated with your account and we'll send you a reset link.",
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
                keyboardType: TextInputType.emailAddress,
                borderColor: AuthColors.forgotFieldBorder,
              ),
              const SizedBox(height: 24),
              GradientAuthButton(
                label: 'Send Reset Link',
                onPressed: () {},
                gradient: AuthColors.forgotButtonGradient,
                borderRadius: 16,
                verticalPadding: 16,
                fontSize: 16,
                trailingIconAsset: 'assets/auth/icon_arrow_right_forgot.svg',
              ),
              const SizedBox(height: 32),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    height: 22.5 / 15,
                    color: AuthColors.subtitle,
                  ),
                  children: [
                    const TextSpan(text: 'Remember your password? '),
                    TextSpan(
                      text: 'Back to Login',
                      style: const TextStyle(color: AuthColors.link),
                      recognizer: TapGestureRecognizer()..onTap = _backToLogin,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    height: 22.5 / 15,
                    color: AuthColors.subtitle,
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
            ],
          ),
        ),
      ),
    );
  }
}
