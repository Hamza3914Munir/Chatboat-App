import 'package:flutter/material.dart';

/// Exact values transcribed from the Figma `Home` frame (2221:132).
abstract final class HomeColors {
  static const screenBackground = Color(0xFFF9FAFB);

  // Header - TopAppBar
  static const appBarBackground = Color(0xFFFCF8FF);
  static const appBarShadow = Color(0x0D000000);
  static const creditPillBackground = Color(0xFFF0EDFF);
  static const creditPillIcon = Color(0xFF635BFF);
  static const creditPillText = Color(0xFF5146D8);

  // Typography
  static const heading = Color(0xFF20212B);
  static const headingDark = Color(0xFF191C1D);
  static const bodyMuted = Color(0xFF70727D);
  static const bodyStrong = Color(0xFF464555);
  static const link = Color(0xFF493EE5);

  // Category cards
  static const cardBackground = Color(0xFFFFFFFF);
  static const cardBorder = Color(0x4DC7C4D8);
  static const cardImageBackground = Color(0xFFF5F2FF);
  static const cardArrowBackground = Color(0x1A635BFF);
  static const cardArrowBorder = Color(0x33493EE5);
  static const cardShadowSoft = Color(0x1A000000);

  // Template cards
  static const templateCardBorder = Color(0xFFE7E6EF);
  static const templateCardShadow = Color(0x0A20212B);
  static const templateBadgeBackground = Color(0x99000000);

  // Recent creations (empty state)
  static const emptyCardBorder = Color(0xFFE9E8F0);
  static const emptyCardShadow = Color(0x08000000);
  static const emptyIconBackground = Color(0xFFEDEEEF);
  static const emptyIcon = Color(0xFF777587);

  // Pro tips
  static const tipCardBorder = Color(0xFFE7E6EF);
  static const tipLightingShadow = Color(0x1A635BFF);
  static const tipStyleShadow = Color(0x1AE65AA8);

  // Pro upgrade card
  static const proButtonBackground = Color(0xFFDFDCDC);
  static const proCardHighlight = Color(0x1AFFFFFF);
  static const proCardGlow = Color(0x33635BFF);

  // Bottom navigation
  static const navBackground = Color(0xFFFFFFFF);
  static const navBorder = Color(0xFFC7C4D8);
  static const navActiveBackground = Color(0xFF635BFF);
  static const navActiveContent = Color(0xFFFEFAFF);
  static const navInactiveContent = Color(0xFF464555);

  // Gradients
  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF635BFF), Color(0xFFE65AA8)],
  );

  static const tipLightingGradient = LinearGradient(
    begin: Alignment(-0.64, -2.32),
    end: Alignment(0.64, 2.32),
    colors: [Color(0xFFF5F7FF), Color(0xFFEEF2FF)],
  );

  static const tipStyleGradient = LinearGradient(
    begin: Alignment(-0.64, -2.32),
    end: Alignment(0.64, 2.32),
    colors: [Color(0xFFFFF5F5), Color(0xFFFFF0F7)],
  );

  static const proCardGradient = LinearGradient(
    begin: Alignment(-1.9, 0),
    end: Alignment(3.9, 0),
    colors: [Color(0xFF635BFF), Color(0xFFD8D8D8), Color(0xFF716CC9)],
    stops: [0.0, 0.29, 0.869],
  );

  // Shared shadow stacks
  static const elevatedCardShadow = <BoxShadow>[
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

  static const navShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
  ];
}
