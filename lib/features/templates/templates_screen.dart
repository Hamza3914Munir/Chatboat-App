import 'package:facepix/core/theme/template_colors.dart';
import 'package:facepix/features/generate/models/generation_flow.dart';
import 'package:facepix/features/generate/screens/template_preview_screen.dart';
import 'package:facepix/features/shell/widgets/app_bottom_nav_bar.dart';
import 'package:facepix/features/templates/template_data.dart';
import 'package:facepix/features/templates/widgets/template_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Template` — one screen with three filter states:
/// All (2229:863), Images (2230:1060) and Videos (2230:1259).
class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key, required this.onNavTap});

  /// Bottom-nav taps pop back to the shell and select that destination, which
  /// is how the design shows this screen: pushed, with the nav still visible
  /// and Home highlighted.
  final ValueChanged<int> onNavTap;

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  TemplateFilter _filter = TemplateFilter.images;
  int _subTab = 0;

  static const _subTabs = ['All', 'Avatars', 'Portraits', 'ID Photos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemplateColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _appBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover Templates',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              height: 42 / 28,
                              color: TemplateColors.heading,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Find the perfect style for your next creation.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              color: TemplateColors.body,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _searchField(),
                          const SizedBox(height: 24),
                          _filterChips(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _content(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNavBar(currentIndex: 0, onTap: widget.onNavTap),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: TemplateColors.appBarBackground,
        boxShadow: [
          BoxShadow(
            color: TemplateColors.appBarShadow,
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Templates',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 24 / 16,
              color: TemplateColors.heading,
            ),
          ),
          Positioned(
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 32,
                height: 32,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/templates/icons/icon_back.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      TemplateColors.heading,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: TemplateColors.searchBackground,
        border: Border.all(color: TemplateColors.searchBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: TemplateColors.appBarShadow,
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          SvgPicture.asset(
            'assets/templates/icons/icon_search.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              TemplateColors.searchIcon,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: TemplateColors.heading,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search templates...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 17.6 / 14,
                  color: TemplateColors.searchPlaceholder,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return Row(
      children: [
        for (final f in TemplateFilter.values) ...[
          if (f != TemplateFilter.values.first) const SizedBox(width: 8),
          _chip(f),
        ],
      ],
    );
  }

  Widget _chip(TemplateFilter filter) {
    final active = _filter == filter;
    final label = switch (filter) {
      TemplateFilter.all => 'All',
      TemplateFilter.images => 'Images',
      TemplateFilter.videos => 'Videos',
    };

    return GestureDetector(
      onTap: () => setState(() => _filter = filter),
      child: Container(
        height: 38,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: active ? null : TemplateColors.chipBackground,
          gradient: active ? TemplateColors.activeChipGradient : null,
          border: active ? null : Border.all(color: TemplateColors.chipBorder),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: active ? TemplateColors.activeChipShadow : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            color: active ? Colors.white : TemplateColors.chipLabel,
          ),
        ),
      ),
    );
  }

  Widget _content() => switch (_filter) {
    TemplateFilter.all => _allState(),
    TemplateFilter.images => _imagesState(),
    TemplateFilter.videos => _videosState(),
  };

  void _openTemplate(GenerationFlow flow, {String badge = 'IMAGE'}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            TemplatePreviewScreen(flow: flow, styleIndex: 0, badge: badge),
      ),
    );
  }

  Widget _sectionHeading(String text) => Text(
    text,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 24 / 17,
      color: TemplateColors.heading,
    ),
  );

  Widget _grid({
    required int count,
    required double spacing,
    required Widget Function(int) builder,
  }) {
    final rows = <Widget>[];
    for (var i = 0; i < count; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: builder(i)),
            const SizedBox(width: 16),
            if (i + 1 < count)
              Expanded(child: builder(i + 1))
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      if (i + 2 < count) rows.add(SizedBox(height: spacing));
    }
    return Column(children: rows);
  }

  Widget _allState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeading('All Templates'),
          const SizedBox(height: 16),
          _grid(
            count: allTemplates.length,
            spacing: 17,
            builder: (i) => AllTemplateCard(
              data: allTemplates[i],
              onTap: () => _openTemplate(
                allTemplates[i].flow,
                badge: allTemplates[i].badge,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeading('Featured'),
          const SizedBox(height: 16),
          _grid(
            count: featuredTemplates.length,
            spacing: 17,
            builder: (i) => AllTemplateCard(
              data: featuredTemplates[i],
              onTap: () => _openTemplate(
                featuredTemplates[i].flow,
                badge: featuredTemplates[i].badge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagesState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _secondaryFilterRow(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _grid(
            count: imageTemplates.length,
            spacing: 28,
            builder: (i) => ImageTemplateCard(
              data: imageTemplates[i],
              onTap: () => _openTemplate(imageTemplates[i].flow),
            ),
          ),
        ),
      ],
    );
  }

  Widget _videosState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _grid(
        count: videoTemplates.length,
        spacing: 13,
        builder: (i) => VideoTemplateCard(
          data: videoTemplates[i],
          onTap: () => _openTemplate(
            GenerationFlow.video,
            badge: videoTemplates[i].badge,
          ),
        ),
      ),
    );
  }

  Widget _secondaryFilterRow() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _subTabs.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            GestureDetector(
              onTap: () => setState(() => _subTab = i),
              child: Container(
                padding: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == _subTab
                          ? TemplateColors.subTabActive
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  _subTabs[i],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 20 / 15,
                    color: i == _subTab
                        ? TemplateColors.subTabActive
                        : TemplateColors.subTabInactive,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
