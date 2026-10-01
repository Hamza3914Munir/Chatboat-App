import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_flow.dart';
import 'package:facepix/features/generate/screens/choose_style_screen.dart';
import 'package:facepix/features/generate/screens/choose_video_style_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Choose Category` (2251:549) — 375x1030.
class ChooseCategoryScreen extends StatelessWidget {
  const ChooseCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GenerateColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FlowHeader(
              title: 'Create with a Photo',
              height: 62,
              background: GenerateColors.headerBackground,
              blurred: false,
              centerTitle: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What can you create with\nyour photo?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 32 / 26,
                        color: GenerateColors.heading,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Turn one photo into creative avatars, professional\nimages, or short AI',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 22 / 14,
                        color: GenerateColors.body,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (var i = 0; i < _categories.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      _CategoryRow(
                        data: _categories[i],
                        onTap: () => _open(context, _categories[i].flow),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, GenerationFlow flow) {
    final config = FlowConfig.of(flow);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => flow == GenerationFlow.video
            ? ChooseVideoStyleScreen(config: config)
            : ChooseStyleScreen(config: config),
      ),
    );
  }
}

class _CategoryData {
  const _CategoryData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.flow,
  });

  final String title;
  final String subtitle;
  final String icon;
  final Color tint;
  final GenerationFlow flow;
}

const _categories = <_CategoryData>[
  _CategoryData(
    title: 'AI Avatars',
    subtitle: 'Creative versions of your photo',
    icon: 'assets/generate/icons/cat_avatars.svg',
    tint: Color(0xFFE2DFFF),
    flow: GenerationFlow.avatar,
  ),
  _CategoryData(
    title: 'Professional Portraits',
    subtitle: 'Studio-style headshots for work & profiles',
    icon: 'assets/generate/icons/cat_portraits.svg',
    tint: Color(0xFFFFD8E7),
    flow: GenerationFlow.portrait,
  ),
  _CategoryData(
    title: 'ID Photos',
    subtitle: 'Passport, visa & ID-ready photos',
    icon: 'assets/generate/icons/cat_id.svg',
    tint: Color(0xFFC3C0FF),
    flow: GenerationFlow.idPhoto,
  ),
  _CategoryData(
    title: 'Professional Photos',
    subtitle: 'High-quality photos for LinkedIn & profiles',
    icon: 'assets/generate/icons/cat_pro_photos.svg',
    tint: Color(0xFFC3C0FF),
    flow: GenerationFlow.portrait,
  ),
  _CategoryData(
    title: 'Animated Photos',
    subtitle: 'Bring your photo to life with subtle motion',
    icon: 'assets/generate/icons/cat_animated.svg',
    tint: Color(0xFFE2DFFF),
    flow: GenerationFlow.video,
  ),
  _CategoryData(
    title: 'Cinematic Clips',
    subtitle: 'Make cinematic clips from images',
    icon: 'assets/generate/icons/cat_cinematic.svg',
    tint: Color(0xFFFFDBCA),
    flow: GenerationFlow.video,
  ),
  _CategoryData(
    title: 'Profile Videos',
    subtitle: 'Short videos for jobs, profiles & social',
    icon: 'assets/generate/icons/cat_profile_video.svg',
    tint: Color(0xFFFFAFD4),
    flow: GenerationFlow.video,
  ),
];

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.data, required this.onTap});

  final _CategoryData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GenerateColors.cardBackground,
          border: Border.all(color: GenerateColors.cardBorder),
          borderRadius: BorderRadius.circular(12),
          boxShadow: GenerateColors.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: data.tint,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(data.icon, width: 17, height: 17),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 18 / 14,
                      color: GenerateColors.heading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Opacity(
                    opacity: 0.80,
                    child: Text(
                      data.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 15 / 12,
                        color: GenerateColors.body,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Opacity(
              opacity: 0.50,
              child: SvgPicture.asset(
                'assets/generate/icons/context_chevron.svg',
                width: 6,
                height: 9,
                colorFilter: const ColorFilter.mode(
                  GenerateColors.chevron,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
