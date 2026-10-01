import 'package:flutter/material.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
    required this.onPressed,
    this.gradient,
    this.gradientBegin = Alignment.topCenter,
    this.gradientEnd = Alignment.bottomCenter,
    this.solidColor,
    this.size = 56,
    this.borderRadius = 16,
  });

  final VoidCallback onPressed;
  final Gradient? gradient;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final Color? solidColor;
  final double size;
  final double borderRadius;

  Gradient? get _resolvedGradient {
    final g = gradient;
    if (g == null) return null;
    if (g is LinearGradient) {
      return LinearGradient(
        begin: gradientBegin,
        end: gradientEnd,
        colors: g.colors,
        stops: g.stops,
      );
    }
    return g;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: solidColor == null ? _resolvedGradient : null,
            color: solidColor,
          ),
          child: const Icon(Icons.chevron_right, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
