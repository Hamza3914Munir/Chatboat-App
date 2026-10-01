import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_flow.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/upload_photo_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Tem Preview` (2236:1921) — the screen a template opens into,
/// which then hands straight off to the upload step.
class TemplatePreviewScreen extends StatelessWidget {
  const TemplatePreviewScreen({
    super.key,
    required this.flow,
    required this.styleIndex,
    this.badge = 'VIDEO • 15 SEC',
  });

  final GenerationFlow flow;
  final int styleIndex;
  final String badge;

  @override
  Widget build(BuildContext context) {
    final config = FlowConfig.of(flow);
    final style = config.styles[styleIndex.clamp(0, config.styles.length - 1)];

    return Scaffold(
      backgroundColor: GenerateColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FlowHeader(
              title: 'Template Preview',
              height: 68,
              background: GenerateColors.headerBackground,
              blurred: false,
              centerTitle: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _hero(style),
                    const SizedBox(height: 20),
                    Text(
                      style.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 33 / 22,
                        color: GenerateColors.heading,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Turn your photo into a polished 15-second introduction\nvideo for job applications, portfolios, and professional\nprofiles.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 19.5 / 13,
                        color: GenerateColors.body,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _Tag('Job Profile'),
                        _Tag('Portfolio'),
                        _Tag('LinkedIn'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'How it works',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 24 / 16,
                        letterSpacing: -0.4,
                        color: GenerateColors.heading,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(
                          child: _HowStep(
                            icon: 'assets/generate/icons/hiw_upload.svg',
                            label: 'Upload\nPhoto',
                          ),
                        ),
                        Expanded(
                          child: _HowStep(
                            icon: 'assets/generate/icons/hiw_magic.svg',
                            label: 'AI\nMagic',
                          ),
                        ),
                        Expanded(
                          child: _HowStep(
                            icon: 'assets/generate/icons/hiw_save.svg',
                            label: 'Save &\nShare',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _proTip(),
                    const SizedBox(height: 24),
                    Text(
                      'Your photo is used only to create your selected result and\nhandled securely.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 18 / 12,
                        color: GenerateColors.body,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '✦ 1 credit per generation',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 18 / 12,
                        color: const Color(0xFF635BFF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => UploadPhotoScreen(
                            session: GenerationSession(
                              config: config,
                              styleIndex: styleIndex,
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: GenerateColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: GenerateColors.buttonShadow,
                        ),
                        child: Text(
                          'Use This Template',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 22.5 / 15,
                            color: Colors.white,
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

  Widget _hero(StyleOption style) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 335 / 378,
            child: Image.asset(
              'assets/generate/styles/template_preview_hero.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              height: 27,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                badge,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 15 / 10,
                  letterSpacing: 0.5,
                  color: GenerateColors.heading,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _proTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GenerateColors.tipBackground,
        border: Border.all(color: GenerateColors.tipBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRO TIP',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 16.5 / 11,
              letterSpacing: 1.1,
              color: const Color(0xFF635BFF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Best Results',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 24 / 16,
              color: GenerateColors.heading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'For the highest quality generation, use a clear,\nfront-facing photo with good lighting and one\nvisible face.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 20.8 / 13,
              color: GenerateColors.body,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDFF),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 18 / 12,
          color: const Color(0xFF635BFF),
        ),
      ),
    );
  }
}

class _HowStep extends StatelessWidget {
  const _HowStep({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: GenerateColors.tipBorder),
            boxShadow: GenerateColors.softShadow,
          ),
          child: SvgPicture.asset(icon, width: 18, height: 18),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 15 / 12,
            letterSpacing: -0.3,
            color: GenerateColors.heading,
          ),
        ),
      ],
    );
  }
}
