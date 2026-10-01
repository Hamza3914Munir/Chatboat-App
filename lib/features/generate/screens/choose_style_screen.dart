import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_flow.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/customize_screen.dart';
import 'package:facepix/features/generate/screens/upload_photo_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Choose style` (2256:2) and its portrait / ID twins
/// (2282:189, 2289:1044) — a 2-column grid of style cards.
class ChooseStyleScreen extends StatefulWidget {
  const ChooseStyleScreen({super.key, required this.config});

  final FlowConfig config;

  @override
  State<ChooseStyleScreen> createState() => _ChooseStyleScreenState();
}

class _ChooseStyleScreenState extends State<ChooseStyleScreen> {
  int _selected = 0;

  void _continue() {
    final session = GenerationSession(
      config: widget.config,
      styleIndex: _selected,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => widget.config.hasCustomize
            ? CustomizeScreen(session: session)
            : UploadPhotoScreen(session: session),
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
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
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
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 21.1 / 13,
                        color: GenerateColors.body,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (var row = 0; row * 2 < styles.length; row++) ...[
                      if (row > 0) const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _card(row * 2)),
                          const SizedBox(width: 16),
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

  Widget _card(int index) => StyleGridCard(
    style: widget.config.styles[index],
    selected: index == _selected,
    onTap: () => setState(() => _selected = index),
  );
}

/// Figma `Style 1: Realistic (Selected)` / `Style 2: 3D Avatar` — 160x240.
///
/// The selected card is a solid gradient with white text: in Figma the
/// gradient sits on top of the whole card as a mask group, and the card's
/// label colours are white, so the artwork is intentionally covered.
class StyleGridCard extends StatelessWidget {
  const StyleGridCard({
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
    final labelColor = selected ? Colors.white : GenerateColors.heading;
    final bodyColor = selected ? Colors.white : GenerateColors.body;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          color: GenerateColors.styleCardBackground,
          gradient: selected ? GenerateColors.selectedStyleGradient : null,
          border: Border.all(color: GenerateColors.styleCardBorder),
          borderRadius: BorderRadius.circular(16),
          boxShadow: GenerateColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 165,
              child: Stack(
                children: [
                  if (!selected)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: SizedBox.expand(
                        child: Image.asset(style.asset, fit: BoxFit.cover),
                      ),
                    ),
                  if (selected)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 19,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF635BFF),
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: GenerateColors.buttonShadow,
                        ),
                        child: SvgPicture.asset(
                          'assets/generate/icons/style_check.svg',
                          width: 11,
                          height: 8,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFEFAFF),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                ],
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 18 / 14,
                        color: labelColor,
                      ),
                    ),
                    const SizedBox(height: 3.375),
                    // Flexible so the two-line description cannot overflow the
                    // card's fixed 240pt height by sub-pixel rounding.
                    Flexible(
                      child: Text(
                        style.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          height: 13.8 / 11,
                          color: bodyColor,
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
}
