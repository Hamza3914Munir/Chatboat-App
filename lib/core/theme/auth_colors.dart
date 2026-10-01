import 'package:flutter/material.dart';

abstract final class AuthColors {
  static const background = Color(0xFFFFFFFF);
  static const title = Color(0xFF20212B);
  static const titleDark = Color(0xFF191C1D);
  static const loginTitle = Color(0xFF111827);
  static const subtitle = Color(0xFF70727D);
  static const loginSubtitle = Color(0xFF6B7280);
  static const label = Color(0xFF191C1D);
  static const hint = Color(0xFF70727D);
  static const fieldBorder = Color(0xFFC7C4D8);
  static const forgotFieldBorder = Color(0xFFD9DADB);
  static const passwordHint = Color(0xFF8A8B96);
  static const termsText = Color(0xFF464555);
  static const link = Color(0xFF493EE5);
  static const loginLink = Color(0xFF635BFF);

  static const emailPillBackground = Color(0xFFF3F4F5);
  static const emailPillBorder = Color(0x4DC7C4D8);
  static const footerPillBackground = Color(0xFFE3E3E4);

  static const dataSharingScrim = Color(0x0FAA2F80);
  static const dataSharingCardBorder = Color(0x3D474552);
  static const dataSharingIconBackground = Color(0xFFF0E8FF);
  static const dataSharingSectionBackground = Color(0xFFF8F9FA);
  static const dataSharingSectionBorder = Color(0xFFE7E8E9);
  static const dataSharingHistoryBackground = Color(0x0D493EE5);
  static const dataSharingHistoryBorder = Color(0x1A493EE5);

  static const buttonGradientStart = Color(0xFF635BFF);
  static const buttonGradientEnd = Color(0xFFF05AA6);

  static const buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [buttonGradientStart, buttonGradientEnd],
  );

  static const loginButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF715BF6), Color(0xFFD45BB8)],
  );

  static const forgotButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7A5BF1), Color(0xFFCB5BBE)],
  );

  static const verificationButtonShadow = Color(0x40635BFF);
}
