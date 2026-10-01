import 'package:facepix/core/theme/home_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Card 1: Avatars` and siblings (2249:45) — 160x255.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.onTap,
    this.subtitleColor = HomeColors.bodyStrong,
    this.subtitleLineHeight = 16.5,
  });

  final String title;
  final String subtitle;
  final String imageAsset;
  final VoidCallback onTap;
  final Color subtitleColor;
  final double subtitleLineHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 255,
        decoration: BoxDecoration(
          color: HomeColors.cardBackground,
          border: Border.all(color: HomeColors.cardBorder),
          borderRadius: BorderRadius.circular(12),
          boxShadow: HomeColors.elevatedCardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
              child: Container(
                height: 128,
                color: HomeColors.cardImageBackground,
                child: Image.asset(imageAsset, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 18 / 14,
                        color: HomeColors.heading,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: subtitleLineHeight / 12,
                        color: subtitleColor,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: HomeColors.cardArrowBackground,
                          border: Border.all(color: HomeColors.cardArrowBorder),
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: const [
                            BoxShadow(
                              color: HomeColors.appBarShadow,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          'assets/home/icons/icon_card_arrow.svg',
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            HomeColors.link,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
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
