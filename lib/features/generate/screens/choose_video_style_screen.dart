import 'dart:ui';

import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_flow.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/customize_video_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Choose ID Style` / Video Styles (2294:466) — a bento grid of
/// 169x239 video style cards.
class ChooseVideoStyleScreen extends StatefulWidget {
  const ChooseVideoStyleScreen({super.key, required this.config});

  final FlowConfig config;

  @override
  State<ChooseVideoStyleScreen> createState() => _ChooseVideoStyleScreenState();
}

class _ChooseVideoStyleScreenState extends State<ChooseVideoStyleScreen> {
  int _selected = 0;

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CustomizeVideoScreen(
          session: GenerationSession(
            config: widget.config,
            styleIndex: _selected,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = widget.config.styles;

    return Scaffold(
      backgroundColor: GenerateColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlowHeader(title: widget.config.appBarTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(13, 24, 13, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.config.styleHeading,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 32 / 24,
                              color: GenerateColors.heading,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            widget.config.styleSubtitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              color: GenerateColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (var row = 0; row * 2 < styles.length; row++) ...[
                      if (row > 0) const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _card(row * 2)),
                          const SizedBox(width: 12),
                          if (row * 2 + 1 < styles.length)
                            Expanded(child: _card(row * 2 + 1))
                          else
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            BottomActionArea(
              privacyNoun: widget.config.privacyNoun,
              onContinue: _continue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(int i) => VideoStyleCard(
    style: widget.config.styles[i],
    selected: i == _selected,
    onTap: () => setState(() => _selected = i),
  );
}

/// Figma `Button - Professional Intro (Active State)` — 169x239.
class VideoStyleCard extends StatelessWidget {
  const VideoStyleCard({
    super.key,
    required this.style,
    required this.selected,
    required this.onTap,
  });

  final StyleOption style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 239,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE2DFFF) : Colors.white,
          border: Border.all(
            color: selected
                ? GenerateColors.link
                : GenerateColors.styleCardBorder,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 4),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 124,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0xFFEDEEF0),
                      child: Image.asset(style.asset, fit: BoxFit.cover),
                    ),
                    Container(color: const Color(0x33000000)),
                    Center(child: _playButton()),
                    const Positioned(left: 8, top: 8, child: _VideoChip()),
                    if (selected)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: GenerateColors.link,
                            shape: BoxShape.circle,
                            boxShadow: GenerateColors.buttonShadow,
                          ),
                          child: SvgPicture.asset(
                            'assets/generate/icons/video_check.svg',
                            width: 11,
                            height: 8,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 20 / 16,
                        color: GenerateColors.headingAlt,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        style.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 18 / 13,
                          color: GenerateColors.body,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (style.duration != null)
                          _MetaChip(
                            label: style.duration!,
                            background: const Color(0xFFE8E8EA),
                            foreground: const Color(0xFF5B5A66),
                          ),
                        if (style.popular) ...[
                          const SizedBox(width: 8),
                          const _MetaChip(
                            label: 'POPULAR',
                            background: Color(0xFFFD6DBB),
                            foreground: Color(0xFF6F0049),
                          ),
                        ],
                      ],
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

  Widget _playButton() => ClipOval(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0x4DFFFFFF),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          'assets/generate/icons/video_play.svg',
          width: 11,
          height: 14,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    ),
  );
}

class _VideoChip extends StatelessWidget {
  const _VideoChip();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 19,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          color: const Color(0x99000000),
          child: Text(
            'VIDEO',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 15 / 10,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 19,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 15 / 10,
          color: foreground,
        ),
      ),
    );
  }
}
