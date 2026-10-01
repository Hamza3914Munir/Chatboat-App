import 'dart:ui';

import 'package:facepix/core/theme/generate_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Translucent, blurred app bar used across the generation flow
/// (Figma `Header`, e.g. 2256:57).
class FlowHeader extends StatelessWidget {
  const FlowHeader({
    super.key,
    required this.title,
    this.height = 72,
    this.background = GenerateColors.headerTranslucent,
    this.blurred = true,
    this.titleColor = GenerateColors.heading,
    this.centerTitle = true,
    this.onBack,
  });

  final String title;
  final double height;
  final Color background;
  final bool blurred;
  final Color titleColor;
  final bool centerTitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      height: height,
      color: background,
      child: Stack(
        alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(left: centerTitle ? 0 : 68, right: 0),
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 24 / 17,
                color: titleColor,
              ),
            ),
          ),
          Positioned(
            left: 12,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/generate/icons/back.svg',
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!blurred) return bar;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: bar,
      ),
    );
  }
}

/// Sticky bottom panel: tip card, primary button and privacy line
/// (Figma `Bottom Action Area`, e.g. 2256:70).
class BottomActionArea extends StatelessWidget {
  const BottomActionArea({
    super.key,
    required this.privacyNoun,
    required this.onContinue,
    this.buttonLabel = 'Continue',
    this.showTip = true,
    this.enabled = true,
  });

  final String privacyNoun;
  final VoidCallback onContinue;
  final String buttonLabel;
  final bool showTip;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: const BoxDecoration(
            color: GenerateColors.actionAreaBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: GenerateColors.actionAreaBorder),
            ),
            boxShadow: [
              BoxShadow(
                color: GenerateColors.actionAreaShadow,
                offset: Offset(0, -8),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showTip) ...[
                const BestResultsTip(),
                const SizedBox(height: 12),
              ],
              GradientActionButton(
                label: buttonLabel,
                onPressed: enabled ? onContinue : null,
              ),
              const SizedBox(height: 12),
              PrivacyFootnote(noun: privacyNoun),
            ],
          ),
        ),
      ),
    );
  }
}

/// `✨ Best results: …` card (Figma `Background+Border`, 2256:71).
class BestResultsTip extends StatelessWidget {
  const BestResultsTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GenerateColors.tipBackground,
        border: Border.all(color: GenerateColors.tipBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨',
            style: GoogleFonts.plusJakartaSans(fontSize: 20, height: 28 / 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Best results: Use a clear, front-facing photo with\ngood lighting and your face fully visible.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 15 / 12,
                color: GenerateColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width gradient button with a trailing arrow (Figma `Button`, 2256:76).
class GradientActionButton extends StatelessWidget {
  const GradientActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 48,
    this.showArrow = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: GenerateColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: GenerateColors.buttonShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 20 / 15,
                  color: Colors.white,
                ),
              ),
              if (showArrow) ...[
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/generate/icons/context_chevron.svg',
                  width: 7.4,
                  height: 12,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// `🔒 Your photo is used only to create your selected …` line.
class PrivacyFootnote extends StatelessWidget {
  const PrivacyFootnote({super.key, required this.noun, this.opacity = 1});

  final String noun;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '\u{1F512}',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 18 / 12),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'Your photo is used only to create your selected $noun.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 15 / 10,
                color: GenerateColors.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
