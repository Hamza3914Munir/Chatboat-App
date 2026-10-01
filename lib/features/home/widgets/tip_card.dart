import 'package:facepix/core/theme/home_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Lighting Tip Card` / `Style Mixing Tip Card` (2233:1582) — 335x98.
class TipCard extends StatelessWidget {
  const TipCard({
    super.key,
    required this.title,
    required this.body,
    required this.imageAsset,
    required this.gradient,
    required this.glowColor,
  });

  final String title;
  final String body;
  final String imageAsset;
  final Gradient gradient;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        border: Border.all(color: HomeColors.tipCardBorder),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: HomeColors.appBarShadow,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 22.5 / 15,
                    color: HomeColors.heading,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  body,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 15 / 12,
                    color: HomeColors.bodyStrong,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
