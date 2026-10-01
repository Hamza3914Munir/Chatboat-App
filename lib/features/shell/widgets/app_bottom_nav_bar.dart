import 'package:facepix/core/theme/home_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom navigation transcribed from Figma `BottomNavBar` (2221:133).
///
/// Item widths, gaps and the asymmetric 42/27 horizontal insets are taken from
/// the frame's rendered geometry rather than its auto-layout values, because
/// the design's own padding + gap values overflow the 375pt frame.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = <_NavItemData>[
    _NavItemData(
      label: 'Home',
      asset: 'assets/home/icons/nav_home.svg',
      width: 65,
      iconWidth: 16,
      iconHeight: 18,
    ),
    _NavItemData(
      label: 'History',
      asset: 'assets/home/icons/nav_history.svg',
      width: 71,
      iconWidth: 18,
      iconHeight: 18,
    ),
    _NavItemData(
      label: 'Profile',
      asset: 'assets/home/icons/nav_profile.svg',
      width: 68,
      iconWidth: 16,
      iconHeight: 16,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: HomeColors.navBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(top: BorderSide(color: HomeColors.navBorder)),
        boxShadow: HomeColors.navShadow,
      ),
      child: Row(
        children: [
          const SizedBox(width: 42),
          for (var i = 0; i < _items.length; i++) ...[
            if (i > 0) const SizedBox(width: 51),
            _NavItem(
              data: _items[i],
              active: currentIndex == i,
              onTap: () => onTap(i),
            ),
          ],
          const SizedBox(width: 27),
        ],
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.asset,
    required this.width,
    required this.iconWidth,
    required this.iconHeight,
  });

  final String label;
  final String asset;
  final double width;
  final double iconWidth;
  final double iconHeight;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.active,
    required this.onTap,
  });

  final _NavItemData data;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = active
        ? HomeColors.navActiveContent
        : HomeColors.navInactiveContent;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: data.width,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? HomeColors.navActiveBackground : null,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              data.asset,
              width: data.iconWidth,
              height: data.iconHeight,
              colorFilter: ColorFilter.mode(content, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 14 / 11,
                letterSpacing: 0.22,
                color: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
