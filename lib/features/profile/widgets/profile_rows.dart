import 'package:facepix/core/theme/profile_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Grouped settings card — Figma `Background+Border+Shadow` (2312:133).
class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) {
        rows.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: ProfileColors.cardBorder,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: ProfileColors.cardBackground,
        border: Border.all(color: ProfileColors.cardBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow: ProfileColors.sectionCardShadow,
      ),
      child: Column(children: rows),
    );
  }
}

/// A settings row with a circular icon, title, optional subtitle and a chevron.
class ProfileRow extends StatelessWidget {
  const ProfileRow({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.iconAsset,
    this.iconWidth = 13,
    this.iconHeight = 13,
    this.trailingAsset = 'assets/profile/icons/icon_chevron.svg',
    this.trailingWidth = 7,
    this.trailingHeight = 12,
    this.titleColor = ProfileColors.rowTitle,
    this.trailingColor = ProfileColors.chevron,
    this.trailingOpacity = 1,
  });

  final String title;
  final String? subtitle;
  final String? iconAsset;
  final double iconWidth;
  final double iconHeight;
  final String trailingAsset;
  final double trailingWidth;
  final double trailingHeight;
  final Color titleColor;
  final Color trailingColor;
  final double trailingOpacity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (iconAsset != null) ...[
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: ProfileColors.rowIconBackground,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  iconAsset!,
                  width: iconWidth,
                  height: iconHeight,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 24 / 16,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 19.5 / 13,
                        color: ProfileColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Opacity(
              opacity: trailingOpacity,
              child: SvgPicture.asset(
                trailingAsset,
                width: trailingWidth,
                height: trailingHeight,
                colorFilter: ColorFilter.mode(trailingColor, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
