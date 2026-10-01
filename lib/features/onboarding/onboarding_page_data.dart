import 'package:flutter/material.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.backgroundColor,
    required this.illustrationAsset,
    required this.titleLines,
    required this.indicatorActiveColor,
    this.indicatorInactiveColor = const Color(0x42FFFFFF),
    this.buttonGradient,
    this.buttonGradientBegin = Alignment.topCenter,
    this.buttonGradientEnd = Alignment.bottomCenter,
    this.buttonSolidColor,
    this.titleFontSize = 28,
    this.bottomPadding = 36,
    this.indicatorBottomPadding = 20,
  });

  final Color backgroundColor;
  final String illustrationAsset;
  final List<String> titleLines;
  final Color indicatorActiveColor;
  final Color indicatorInactiveColor;
  final Gradient? buttonGradient;
  final AlignmentGeometry buttonGradientBegin;
  final AlignmentGeometry buttonGradientEnd;
  final Color? buttonSolidColor;
  final double titleFontSize;
  final double bottomPadding;
  final double indicatorBottomPadding;
}
