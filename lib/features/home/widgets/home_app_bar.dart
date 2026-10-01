import 'package:facepix/core/theme/home_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Header - TopAppBar` (2221:152) — 375x64.
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: HomeColors.appBarBackground,
        boxShadow: [
          BoxShadow(
            color: HomeColors.appBarShadow,
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The logo is 100x48 and deliberately overflows the 32pt tall
          // container in Figma; centring it in the 64pt bar reproduces that.
          SizedBox(
            width: 100,
            height: 48,
            child: Image.asset(
              'assets/home/logo_wordmark.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: HomeColors.creditPillBackground,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: HomeColors.appBarShadow,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/home/icons/icon_credit.svg',
                  width: 13,
                  height: 13,
                  colorFilter: const ColorFilter.mode(
                    HomeColors.creditPillIcon,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$credits Credits',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 19.5 / 13,
                    color: HomeColors.creditPillText,
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
