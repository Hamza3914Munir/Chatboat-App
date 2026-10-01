import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Section - Selected Style Summary` (2284:684) — 320x102.
class SelectedStyleSummary extends StatelessWidget {
  const SelectedStyleSummary({
    super.key,
    required this.session,
    required this.onChangeStyle,
  });

  final GenerationSession session;
  final VoidCallback onChangeStyle;

  @override
  Widget build(BuildContext context) {
    final style = session.style;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 64,
              height: 64,
              color: const Color(0xFFE8E8EA),
              child: Image.asset(style.asset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 24 / 16,
                    color: GenerateColors.headingAlt,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Professional ${session.config.privacyNoun.toLowerCase()}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 18 / 13,
                    color: GenerateColors.body,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onChangeStyle,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Change style',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                          letterSpacing: 0.12,
                          color: GenerateColors.link,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        'assets/generate/icons/change_style_arrow.svg',
                        width: 9,
                        height: 9,
                        colorFilter: const ColorFilter.mode(
                          GenerateColors.link,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
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

/// Figma `Context Card` (2267:14) — the 335x66 style strip on the upload screen.
class StyleContextCard extends StatelessWidget {
  const StyleContextCard({super.key, required this.session, this.onTap});

  final GenerationSession session;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = session.style;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 66,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GenerateColors.styleCardBorder),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(style.asset, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    style.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 18 / 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    session.config.mediaKindLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 14 / 11,
                      letterSpacing: 0.55,
                      color: GenerateColors.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/generate/icons/context_chevron.svg',
              width: 7,
              height: 12,
              colorFilter: const ColorFilter.mode(
                GenerateColors.contextChevron,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
