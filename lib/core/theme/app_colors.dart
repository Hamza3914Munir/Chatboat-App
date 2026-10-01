import 'package:flutter/material.dart';

abstract final class AppColors {
  static const splashBackground = Color(0xFFFFFFFF);

  // Onboarding screen backgrounds (Figma)
  static const onboardingYellow = Color(0xFFFFD400);
  static const onboardingCoral = Color(0xFFFF6B4A);
  static const onboardingPurple = Color(0xFF6A5AE0);
  static const onboardingPink = Color(0xFFFF5DA8);

  static const onboardingPurpleSolid = Color(0xFF6C63FF);
  static const onboardingYellowAccent = Color(0xFFFFCC1D);

  static const onboardingBluePurpleGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF5B7FFF), Color(0xFF6C63FF)],
  );

  static const indicatorInactiveWhite = Color(0x42FFFFFF);
  static const indicatorInactiveBlueViolet = Color(0x666C63FF);
  static const indicatorInactiveTan = Color(0x66C4A882);
  static const indicatorInactiveYellowMuted = Color(0x66FFCC1D);
}
