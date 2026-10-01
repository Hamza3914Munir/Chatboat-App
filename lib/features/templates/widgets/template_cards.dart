import 'dart:ui';

import 'package:facepix/core/theme/template_colors.dart';
import 'package:facepix/features/templates/template_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// `Corporate Headshot (IMAGE)` and siblings (2229:951) — 160x234.
class AllTemplateCard extends StatelessWidget {
  const AllTemplateCard({super.key, required this.data, required this.onTap});

  final AllTemplate data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 234,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: TemplateColors.cardBorder),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: TemplateColors.cardShadow,
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
                    top: Radius.circular(19),
                  ),
                  child: SizedBox(
                    height: 140,
                    child: Image.asset(data.asset, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: _OverlayBadge(
                    label: data.badge,
                    iconAsset: data.isVideo
                        ? 'assets/templates/icons/icon_badge_video.svg'
                        : 'assets/home/icons/icon_badge_image.svg',
                  ),
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
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 18 / 14,
                        color: TemplateColors.heading,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        height: 16.5 / 11,
                        color: TemplateColors.body,
                      ),
                    ),
                    const Spacer(),
                    _UseTemplateLink(
                      color: TemplateColors.linkAlt,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      lineHeight: 18 / 12,
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

/// `Card 1` and siblings (2230:1113) — 160x270, the Images filter state.
class ImageTemplateCard extends StatelessWidget {
  const ImageTemplateCard({super.key, required this.data, required this.onTap});

  final ImageTemplate data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 270,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: TemplateColors.cardBorder),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: TemplateColors.cardShadow,
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
                    top: Radius.circular(11),
                  ),
                  child: SizedBox(
                    height: 160,
                    child: Image.asset(data.asset, fit: BoxFit.cover),
                  ),
                ),
                const Positioned(left: 8, top: 8, child: _ImageChipBadge()),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 18 / 14,
                        color: TemplateColors.heading,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 15 / 12,
                        color: TemplateColors.body,
                      ),
                    ),
                    const Spacer(),
                    _UseTemplateLink(
                      color: TemplateColors.link,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      lineHeight: 20 / 14,
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

/// `Template Card 1` and siblings (2230:1316) — 162x297, the Videos state.
class VideoTemplateCard extends StatelessWidget {
  const VideoTemplateCard({super.key, required this.data, required this.onTap});

  final VideoTemplate data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 297,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: TemplateColors.cardBorder),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: TemplateColors.cardShadow,
              offset: Offset(0, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: TemplateColors.videoArtworkBackground,
                      child: Image.asset(data.asset, fit: BoxFit.cover),
                    ),
                    Container(color: TemplateColors.videoArtworkScrim),
                    Center(
                      child: SvgPicture.asset(
                        'assets/templates/icons/icon_play.svg',
                        width: 27,
                        height: 27,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      top: 8,
                      child: _DurationBadge(label: data.badge),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 11.5),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 19.5 / 13,
                color: TemplateColors.heading,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 13.8 / 11,
                color: TemplateColors.body,
              ),
            ),
            const SizedBox(height: 11.5),
            _UseTemplateLink(
              color: TemplateColors.link,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              lineHeight: 18 / 12,
            ),
          ],
        ),
      ),
    );
  }
}

class _UseTemplateLink extends StatelessWidget {
  const _UseTemplateLink({
    required this.color,
    required this.fontSize,
    required this.fontWeight,
    required this.lineHeight,
  });

  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Use Template',
          style: GoogleFonts.plusJakartaSans(
            fontSize: fontSize,
            fontWeight: fontWeight,
            height: lineHeight,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        SvgPicture.asset(
          'assets/home/icons/icon_link_arrow.svg',
          width: 9,
          height: 9,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ],
    );
  }
}

/// Solid lilac `IMAGE` chip used on the Images-state cards.
class _ImageChipBadge extends StatelessWidget {
  const _ImageChipBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: TemplateColors.badgeChipBackground,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/templates/icons/icon_badge_image_chip.svg',
            width: 9,
            height: 9,
            colorFilter: const ColorFilter.mode(
              TemplateColors.badgeChipContent,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'IMAGE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 15 / 10,
              letterSpacing: 0.5,
              color: TemplateColors.badgeChipContent,
            ),
          ),
        ],
      ),
    );
  }
}

/// Translucent blurred pill (`IMAGE` / `10s`) on the All-state cards.
class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge({required this.label, required this.iconAsset});

  final String label;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: 22,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: TemplateColors.badgeOverlay,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconAsset,
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

/// `VIDEO • 5S` pill on the Videos-state cards.
class _DurationBadge extends StatelessWidget {
  const _DurationBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: 18,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          color: TemplateColors.badgeOverlay,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              height: 13.5 / 9,
              letterSpacing: 0.45,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
