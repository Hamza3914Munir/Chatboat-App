import 'dart:io';

import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/generating_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Result` (2279:2 and its twins) — 375x884.
///
/// Until generation is wired up the hero shows the user's own photo, which is
/// what the design mocks up too.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.session});

  final GenerationSession session;

  @override
  Widget build(BuildContext context) {
    final config = session.config;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlowHeader(
              title: config.resultPreviewLabel,
              height: 64,
              background: GenerateColors.errorHeaderBackground,
              blurred: false,
              titleColor: GenerateColors.headingAlt,
            ),
            _successStrip(config.resultSuccess),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _hero(),
                    const SizedBox(height: 24),
                    Text(
                      config.resultReady,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 27.5 / 22,
                        color: GenerateColors.headingAlt,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      config.resultBody,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        color: GenerateColors.body,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _actions(context),
                    const SizedBox(height: 24),
                    Center(child: _tryAnotherStyle(context)),
                    const SizedBox(height: 24),
                    Center(child: _creditsRow()),
                    const SizedBox(height: 16),
                    PrivacyFootnote(noun: config.privacyNoun),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _successStrip(String label) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      color: const Color(0x4DE2DFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/generate/icons/success.svg',
            width: 15,
            height: 15,
            colorFilter: const ColorFilter.mode(
              GenerateColors.link,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: GenerateColors.link,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    final photo = session.photoPath;
    return Container(
      height: 280,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26493EE5),
            offset: Offset(0, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: const Color(0xFFE2E2E4),
              child: photo == null
                  ? null
                  : Image.file(File(photo), fit: BoxFit.cover),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(child: StyleChipOverlay(session: session)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(-0.5, -1),
                    end: Alignment(0.5, 1),
                    colors: [Color(0xFF493EE5), Color(0xFFFD6DBB)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: GenerateColors.buttonShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/generate/icons/save.svg',
                      width: 13,
                      height: 13,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Save to Device',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 24 / 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 60,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: GenerateColors.styleCardBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                'assets/generate/icons/share.svg',
                width: 18,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  GenerateColors.body,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => GeneratingScreen(session: session),
            ),
          ),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: GenerateColors.styleCardBorder),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/generate/icons/regenerate.svg',
                  width: 13,
                  height: 13,
                  colorFilter: const ColorFilter.mode(
                    GenerateColors.link,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Regenerate',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 24 / 16,
                    color: GenerateColors.link,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '· 1 credit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13,
                    color: GenerateColors.body,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tryAnotherStyle(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Try another style',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
              color: GenerateColors.link,
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/generate/icons/refresh.svg',
            width: 11,
            height: 11,
            colorFilter: const ColorFilter.mode(
              GenerateColors.link,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/generate/icons/credits.svg',
          width: 15,
          height: 11,
          colorFilter: const ColorFilter.mode(
            GenerateColors.body,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '4 credits remaining',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 20 / 13,
            color: GenerateColors.body,
          ),
        ),
      ],
    );
  }
}
