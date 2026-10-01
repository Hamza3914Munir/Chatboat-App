import 'dart:ui';

import 'package:facepix/core/theme/home_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Card 1: Avatar` and siblings (2222:423) — 160x202.
class TemplateCard extends StatelessWidget {
  const TemplateCard({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.onTap,
    this.badgeLabel,
  });

  final String title;
  final String imageAsset;
  final VoidCallback onTap;

  /// `IMAGE` / `VIDEO` pill shown over the artwork. Only the first two cards
  /// carry one in the design.
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 202,
        decoration: BoxDecoration(
          color: HomeColors.cardBackground,
          border: Border.all(color: HomeColors.templateCardBorder),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: HomeColors.templateCardShadow,
              offset: Offset(0, 4),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Container(
                    height: 140,
                    color: HomeColors.cardImageBackground,
                    child: Image.asset(imageAsset, fit: BoxFit.cover),
                  ),
                ),
                if (badgeLabel != null)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _Badge(label: badgeLabel!),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 19.5 / 13,
                        color: HomeColors.heading,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Use Template',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                            color: HomeColors.link,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/home/icons/icon_link_arrow.svg',
                          width: 9,
                          height: 9,
                          colorFilter: const ColorFilter.mode(
                            HomeColors.link,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: 22,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: HomeColors.templateBadgeBackground,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/home/icons/icon_badge_image.svg',
                width: 9,
                height: 9,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  height: 13.5 / 9,
                  letterSpacing: 0.45,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
