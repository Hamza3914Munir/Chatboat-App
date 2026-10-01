import 'dart:ui';

import 'package:facepix/core/theme/home_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Card` (2234:1638) — the 335x255 "Upgrade to Pro" panel.
class ProUpgradeCard extends StatelessWidget {
  const ProUpgradeCard({super.key, required this.onUpgrade});

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    // Height is intentionally intrinsic: Figma's own content block (207pt) plus
    // its 24pt padding rounds to 256, 1pt over the 255pt frame.
    return Container(
      decoration: BoxDecoration(
        gradient: HomeColors.proCardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              left: 271,
              top: -64,
              child: _Glow(
                size: 128,
                blur: 40,
                color: HomeColors.proCardHighlight,
              ),
            ),
            const Positioned(
              left: -48,
              top: 207,
              child: _Glow(size: 96, blur: 24, color: HomeColors.proCardGlow),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 64pt slot; the 154x74 wordmark deliberately overflows it,
                  // matching the Figma layer.
                  SizedBox(
                    width: 152,
                    height: 64,
                    child: OverflowBox(
                      maxWidth: 154,
                      maxHeight: 74,
                      child: Image.asset(
                        'assets/home/logo_wordmark.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.90,
                    child: Column(
                      children: const [
                        _Feature(label: 'Unlimited generations', gap: 8),
                        SizedBox(height: 4),
                        _Feature(label: 'Early access to styles ', gap: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: onUpgrade,
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: HomeColors.proButtonBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: HomeColors.elevatedCardShadow,
                      ),
                      child: Text(
                        'Upgrade to Pro',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 24 / 16,
                          color: HomeColors.link,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Opacity(
                    opacity: 0.70,
                    child: Text(
                      'Starting at \$9.99/month',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        height: 16.5 / 11,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.label, required this.gap});

  final String label;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/home/icons/icon_pro_check.svg',
          width: 13,
          height: 13,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
        SizedBox(width: gap),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 19.5 / 13,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.blur, required this.color});

  final double size;
  final double blur;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
