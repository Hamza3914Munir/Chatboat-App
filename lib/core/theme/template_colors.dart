import 'package:flutter/material.dart';

/// Exact values from the Figma `Template` frames (2229:863 / 2230:1060 / 2230:1259).
abstract final class TemplateColors {
  static const screenBackground = Color(0xFFF9FAFB);
  static const canvasBackground = Color(0xFFFFFFFF);

  static const appBarBackground = Color(0xFFFCF8FF);
  static const appBarShadow = Color(0x0D000000);

  static const heading = Color(0xFF1B1B24);
  static const body = Color(0xFF464555);

  // Search field
  static const searchBackground = Color(0xFFFFFFFF);
  static const searchBorder = Color(0xFFC7C4D8);
  static const searchPlaceholder = Color(0xFF6B7280);
  static const searchIcon = Color(0xFF777587);

  // Primary filter chips
  static const chipBackground = Color(0xFFFCF8FF);
  static const chipBorder = Color(0xFFC7C4D8);
  static const chipLabel = Color(0xFF000000);

  // Secondary (underline) filter row
  static const subTabActive = Color(0xFF493EE5);
  static const subTabInactive = Color(0xFF777587);

  // Cards
  static const cardBorder = Color(0xFFE7E6EF);
  static const cardShadow = Color(0x0A20212B);
  static const link = Color(0xFF493EE5);
  static const linkAlt = Color(0xFF635BFF);

  // Badges
  static const badgeChipBackground = Color(0xFFF0EDFF);
  static const badgeChipContent = Color(0xFF5146D8);
  static const badgeOverlay = Color(0x99000000);

  // Video card artwork
  static const videoArtworkBackground = Color(0xFFF0ECFA);
  static const videoArtworkScrim = Color(0x33000000);

  static const activeChipGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF635BFF), Color(0xFFE65AA8)],
  );

  static const activeChipShadow = <BoxShadow>[
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
}
