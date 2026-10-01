import 'package:flutter/material.dart';

/// Exact values from the Figma `Profile` frame (2312:95).
abstract final class ProfileColors {
  static const background = Color(0xFFF9F9FB);
  static const cardBackground = Color(0xFFFFFFFF);
  static const cardBorder = Color(0xFFC7C4D8);
  static const cardShadow = Color(0x0D000000);

  static const name = Color(0xFF191C1E);
  static const rowTitle = Color(0xFF1A1C1D);
  static const muted = Color(0xFF464555);
  static const chevron = Color(0xFF777587);
  static const accent = Color(0xFF9B62E7);
  static const danger = Color(0xFFBA1A1A);

  static const verifiedPillBackground = Color(0xFFF3F3F5);
  static const rowIconBackground = Color(0xFFEDEEF0);
  static const avatarRing = Color(0xFFF9F9FB);

  static const upgradeGradient = LinearGradient(
    begin: Alignment(-0.61, -2.87),
    end: Alignment(0.61, 2.87),
    colors: [Color(0xFF635BFF), Color(0xFFFD6DBB)],
  );

  static const buttonShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  static const sectionCardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 4), blurRadius: 20),
  ];
}
