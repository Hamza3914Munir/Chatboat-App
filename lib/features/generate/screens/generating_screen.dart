import 'dart:io';
import 'dart:ui';

import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/result_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Genrating screen` (2274:118 and its twins) — 375x884.
///
/// With no generation backend yet the progress is simulated; the step list and
/// bar advance on a timer and then hand off to the result screen.
class GeneratingScreen extends StatefulWidget {
  const GeneratingScreen({super.key, required this.session});

  final GenerationSession session;

  @override
  State<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<GeneratingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 4200),
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _finish();
      });

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(session: widget.session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.session.config;

    return Scaffold(
      backgroundColor: GenerateColors.errorScreenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlowHeader(
              title: config.generatingCaption,
              height: 66,
              background: GenerateColors.errorHeaderBackground,
              blurred: false,
              titleColor: GenerateColors.headingAlt,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final progress = _controller.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _hero(),
                        const SizedBox(height: 32),
                        Text(
                          config.generatingTitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 36 / 24,
                            color: const Color(0xFF161A2E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Please wait a few seconds. Our AI is\ncrafting the perfect version of you.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 24 / 15,
                            color: const Color(0xFF474552),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _progressBar(progress),
                        const SizedBox(height: 32),
                        _steps(progress),
                        const SizedBox(height: 24),
                        PrivacyFootnote(noun: config.privacyNoun),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    final photo = widget.session.photoPath;
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E4),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (photo != null) Image.file(File(photo), fit: BoxFit.cover),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(child: StyleChipOverlay(session: widget.session)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressBar(double progress) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E4),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.05, 1),
        child: Container(
          decoration: BoxDecoration(
            gradient: GenerateColors.errorCtaGradient,
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
    );
  }

  Widget _steps(double progress) {
    final config = widget.session.config;
    final labels = [
      'Photo verified',
      config.generatingStepLabel,
      'Finalizing result',
    ];
    // Step 1 is already done on arrival — the face check ran on the previous
    // screen — so the timer only drives steps 2 and 3.
    final activeIndex = progress < 0.6 ? 1 : 2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEDEEF0)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _StepRow(
              label: labels[i],
              state: i < activeIndex
                  ? _StepState.done
                  : i == activeIndex
                  ? _StepState.active
                  : _StepState.pending,
            ),
          ],
        ],
      ),
    );
  }
}

enum _StepState { done, active, pending }

class _StepRow extends StatelessWidget {
  const _StepRow({required this.label, required this.state});

  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _indicator(),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 24 / 16,
              color: switch (state) {
                _StepState.done => GenerateColors.headingAlt,
                _StepState.active => GenerateColors.link,
                _StepState.pending => GenerateColors.muted,
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _indicator() {
    switch (state) {
      case _StepState.done:
        return Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE2DFFF),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/generate/icons/step_done.svg',
            width: 10,
            height: 7,
            colorFilter: const ColorFilter.mode(
              GenerateColors.link,
              BlendMode.srcIn,
            ),
          ),
        );
      case _StepState.active:
        return Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: GenerateColors.errorCtaGradient,
            shape: BoxShape.circle,
          ),
          child: const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        );
      case _StepState.pending:
        return Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE2E2E4),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/generate/icons/step_pending.svg',
            width: 14,
            height: 13,
            colorFilter: const ColorFilter.mode(
              GenerateColors.muted,
              BlendMode.srcIn,
            ),
          ),
        );
    }
  }
}

/// Figma `Style Chip overlay` — the frosted pill naming the chosen style.
class StyleChipOverlay extends StatelessWidget {
  const StyleChipOverlay({super.key, required this.session});

  final GenerationSession session;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xE6E2DFFF),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: GenerateColors.softShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/generate/icons/style_chip.svg',
                width: 13,
                height: 13,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF321ED2),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                session.style.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 16 / 12,
                  letterSpacing: 0.12,
                  color: const Color(0xFF321ED2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
