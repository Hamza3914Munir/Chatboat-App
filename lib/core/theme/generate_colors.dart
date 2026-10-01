import 'package:flutter/material.dart';

/// Exact values from the Figma generation-flow frames
/// (Choose Category 2251:549, style / upload / error / generating / result).
abstract final class GenerateColors {
  static const screenBackground = Color(0xFFFCF8FF);
  static const errorScreenBackground = Color(0xFFFAFAFC);

  static const headerBackground = Color(0xFFFCF8FF);
  static const headerTranslucent = Color(0xCCFCF8FF);
  static const errorHeaderBackground = Color(0xFFF9F9FB);
  static const headerShadow = Color(0x0D000000);

  static const heading = Color(0xFF1B1B24);
  static const headingAlt = Color(0xFF1A1C1D);
  static const body = Color(0xFF464555);
  static const muted = Color(0xFF777587);
  static const link = Color(0xFF493EE5);

  static const cardBackground = Color(0xFFFFFFFF);
  static const cardBorder = Color(0xFFE8E6F0);
  static const styleCardBackground = Color(0xFFFCF8FF);
  static const styleCardBorder = Color(0xFFC7C4D8);
  static const chevron = Color(0xFF838385);

  // Bottom action area
  static const actionAreaBackground = Color(0xF2FCF8FF);
  static const actionAreaBorder = Color(0xFFC7C4D8);
  static const actionAreaShadow = Color(0x0D000000);
  static const tipBackground = Color(0xFFF5F2FF);
  static const tipBorder = Color(0x4DC7C4D8);

  // Upload
  static const uploadDashBorder = Color(0xFFC7C4D8);
  static const uploadIcon = Color(0xFF464555);
  static const contextChevron = Color(0xFFC7C4D8);

  // Error
  static const errorBadgeBackground = Color(0xFFFFDAD6);
  static const errorBadgeBorder = Color(0x33BA1A1A);
  static const errorBadgeContent = Color(0xFF93000A);
  static const errorCardBackground = Color(0xFFF5F1FF);
  static const errorCardBorder = Color(0x80E2DFFF);
  static const errorPreviewGlow = Color(0x80FFDAD6);
  static const outlineButtonBorder = Color(0x33493EE5);

  // Generating
  static const stepDoneBackground = Color(0xFFEDEBFF);
  static const stepPendingBackground = Color(0xFFF1F1F4);

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF635BFF), Color(0xFFE65AA8)],
  );

  /// The 35° overlay that tints a selected style card.
  static const selectedStyleGradient = LinearGradient(
    begin: Alignment(-1, -0.7),
    end: Alignment(1, 0.7),
    colors: [Color(0xFF635BFF), Color(0xFFE65AA8)],
  );

  static const errorCtaGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF493EE5), Color(0xFFAA2776)],
  );

  static const cameraButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF6039CB), Color(0xFF982B8B)],
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

  static const softShadow = <BoxShadow>[
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2),
  ];
}
