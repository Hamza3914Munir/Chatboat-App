import 'package:facepix/core/theme/home_colors.dart';
import 'package:facepix/features/generate/models/generation_flow.dart';
import 'package:facepix/features/generate/screens/choose_category_screen.dart';
import 'package:facepix/features/generate/screens/choose_style_screen.dart';
import 'package:facepix/features/generate/screens/choose_video_style_screen.dart';
import 'package:facepix/features/home/widgets/category_card.dart';
import 'package:facepix/features/home/widgets/home_app_bar.dart';
import 'package:facepix/features/home/widgets/pro_upgrade_card.dart';
import 'package:facepix/features/home/widgets/template_card.dart';
import 'package:facepix/features/home/widgets/tip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Home` (2221:132) — 375x2242.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.credits,
    required this.onOpenTemplates,
  });

  final int credits;
  final VoidCallback onOpenTemplates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeAppBar(credits: credits),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _welcome(context),
                      const SizedBox(height: 32),
                      _sectionHeading('What can you create?'),
                      const SizedBox(height: 32),
                      _categoryGrid(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                _templatesSection(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _recentCreations(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _proTips(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ProUpgradeCard(onUpgrade: () {}),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _welcome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What will you create today?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 32 / 26,
            color: HomeColors.heading,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Turn your photo into something amazing with AI.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 19.5 / 13,
            color: HomeColors.bodyMuted,
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => _openCategories(context),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: HomeColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: HomeColors.elevatedCardShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/home/icons/icon_create_photo.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Create with a Photo',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 20 / 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openCategories(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ChooseCategoryScreen()),
    );
  }

  void _openFlow(BuildContext context, GenerationFlow flow) {
    final config = FlowConfig.of(flow);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => flow == GenerationFlow.video
            ? ChooseVideoStyleScreen(config: config)
            : ChooseStyleScreen(config: config),
      ),
    );
  }

  Widget _sectionHeading(String text) => Text(
    text,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 24 / 17,
      color: HomeColors.heading,
    ),
  );

  Widget _categoryGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CategoryCard(
                title: 'Avatars',
                subtitle: 'Creative versions of\nyou',
                imageAsset: 'assets/home/cat_avatars.png',
                onTap: () => _openFlow(context, GenerationFlow.avatar),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CategoryCard(
                title: 'Portraits',
                subtitle: 'Polished professional\nportraits',
                imageAsset: 'assets/home/cat_portraits.png',
                onTap: () => _openFlow(context, GenerationFlow.portrait),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CategoryCard(
                title: 'ID Photos',
                subtitle: 'Passport & ID-ready\nphotos',
                imageAsset: 'assets/home/cat_id_photos.png',
                onTap: () => _openFlow(context, GenerationFlow.idPhoto),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CategoryCard(
                title: 'Videos',
                subtitle: 'Bring photos to \nlife',
                imageAsset: 'assets/home/cat_videos.png',
                onTap: () => _openFlow(context, GenerationFlow.video),
                subtitleColor: HomeColors.bodyMuted,
                subtitleLineHeight: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _templatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _sectionHeading('Try a Template'),
                  GestureDetector(
                    onTap: onOpenTemplates,
                    child: Text(
                      'View All →',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 20 / 14,
                        color: HomeColors.link,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Not sure what to create? Start with a ready-made style.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  color: HomeColors.bodyStrong,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _templates.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final t = _templates[i];
              return TemplateCard(
                title: t.title,
                imageAsset: t.asset,
                badgeLabel: t.badge,
                onTap: onOpenTemplates,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _recentCreations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Recent Creations',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 32 / 24,
                color: HomeColors.headingDark,
              ),
            ),
            Text(
              'View All →',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 20 / 14,
                color: HomeColors.link,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: HomeColors.emptyCardBorder),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: HomeColors.emptyCardShadow,
                offset: Offset(0, 4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: HomeColors.emptyIconBackground,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/home/icons/icon_empty_creations.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    HomeColors.emptyIcon,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No creations yet. Your AI\ncreations will appear here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  color: HomeColors.bodyStrong,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _proTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeading('Pro Tips'),
        const SizedBox(height: 16),
        const TipCard(
          title: 'Master Lighting',
          body:
              'Use soft, natural light for the most realistic AI transformations.',
          imageAsset: 'assets/home/tip_lighting.png',
          gradient: HomeColors.tipLightingGradient,
          glowColor: HomeColors.tipLightingShadow,
        ),
        const SizedBox(height: 16),
        const TipCard(
          title: 'Mix Your Styles',
          body:
              'Combine different artistic prompts to\ncreate a unique signature look.',
          imageAsset: 'assets/home/tip_style_mixing.png',
          gradient: HomeColors.tipStyleGradient,
          glowColor: HomeColors.tipStyleShadow,
        ),
      ],
    );
  }
}

class _Template {
  const _Template(this.title, this.asset, this.badge);
  final String title;
  final String asset;
  final String? badge;
}

const _templates = <_Template>[
  _Template('Neon Avatar', 'assets/home/tpl_neon_avatar.png', 'IMAGE'),
  _Template('Pro Portrait', 'assets/home/tpl_pro_portrait.png', 'IMAGE'),
  _Template('Dynamic Motion', 'assets/home/tpl_dynamic_motion.png', null),
  _Template('Corporate AI', 'assets/home/tpl_corporate_ai.png', null),
];
