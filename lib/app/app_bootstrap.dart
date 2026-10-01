import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/core/preferences/onboarding_preferences.dart';
import 'package:facepix/core/preferences/registration_preferences.dart';
import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:facepix/features/auth/email_verification_screen.dart';
import 'package:facepix/features/shell/app_shell.dart';
import 'package:facepix/features/onboarding/onboarding_screen.dart';
import 'package:facepix/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  static const _splashDuration = Duration(milliseconds: 1800);

  @override
  void initState() {
    super.initState();
    _resolveInitialRoute();
  }

  Future<void> _resolveInitialRoute() async {
    await Future<void>.delayed(_splashDuration);
    final completed = await OnboardingPreferences.isCompleted();
    final registered = await RegistrationPreferences.isCompleted();
    final emailVerified = await AuthFlowPreferences.isEmailVerified();
    if (!mounted) return;

    final Widget next;
    if (!completed) {
      next = const OnboardingScreen();
    } else if (!registered) {
      next = const CreateAccountScreen();
    } else if (!emailVerified) {
      next = const EmailVerificationScreen();
    } else {
      next = const AppShell();
    }

    await Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
