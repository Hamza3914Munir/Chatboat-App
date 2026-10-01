import 'dart:ui';

import 'package:facepix/core/theme/history_colors.dart';
import 'package:facepix/features/history/history_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Card: Corporate Headshot (Portrait)` and siblings (2304:1039) — 152x191.
class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onMenu,
  });

  final HistoryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 191,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: HistoryColors.cardBorder),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: HistoryColors.cardShadow,
              offset: Offset(0, 1),
              blurRadius: 2,
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
                      color: HistoryColors.artworkBackground,
                      child: Image.asset(entry.asset, fit: BoxFit.cover),
                    ),
                    if (entry.isVideo) const Center(child: _PlayButton()),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: _MenuButton(onTap: onMenu),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 9,
                      child: _KindBadge(entry: entry),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 19.5 / 13,
                        color: HistoryColors.title,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.timeAgo,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      height: 16.5 / 11,
                      color: HistoryColors.subtitle,
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

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: HistoryColors.playButtonBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: HistoryColors.cardShadow,
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/history/icons/icon_play.svg',
            width: 11,
            height: 14,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            color: HistoryColors.menuButtonBackground,
            child: SvgPicture.asset(
              'assets/history/icons/icon_menu.svg',
              width: 3,
              height: 11,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KindBadge extends StatelessWidget {
  const _KindBadge({required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final (background, label) = switch (entry.kind) {
      CreationKind.portrait => (
        HistoryColors.badgePortraitBackground,
        HistoryColors.badgePortraitLabel,
      ),
      CreationKind.video => (
        HistoryColors.badgeVideoBackground,
        HistoryColors.badgeVideoLabel,
      ),
      CreationKind.idPhoto => (
        HistoryColors.badgeIdBackground,
        HistoryColors.badgeIdLabel,
      ),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: 19,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          color: background,
          child: Text(
            entry.badgeLabel,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 15 / 10,
              letterSpacing: 0.5,
              color: label,
            ),
          ),
        ),
      ),
    );
  }
}
