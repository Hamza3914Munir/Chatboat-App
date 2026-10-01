import 'dart:io';

import 'package:facepix/core/services/face_check_service.dart';
import 'package:facepix/core/services/photo_picker_service.dart';
import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/generating_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Error` (2271:2 and its portrait / ID / video twins) — 375x884.
///
/// The design has a single error screen covering every failure, so the copy
/// is deliberately generic regardless of which check failed.
class FaceErrorScreen extends StatefulWidget {
  const FaceErrorScreen({
    super.key,
    required this.session,
    required this.failure,
  });

  final GenerationSession session;
  final FaceCheckFailure failure;

  @override
  State<FaceErrorScreen> createState() => _FaceErrorScreenState();
}

class _FaceErrorScreenState extends State<FaceErrorScreen> {
  final _picker = PhotoPickerService();
  final _faceCheck = const FaceCheckService();
  bool _busy = false;

  Future<void> _retry({required bool camera}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final path = camera
          ? await _picker.takePhoto()
          : await _picker.pickFromGallery();
      if (path == null || !mounted) return;

      final result = await _faceCheck.check(path);
      if (!mounted) return;

      widget.session.photoPath = path;
      if (result.passed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => GeneratingScreen(session: widget.session),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => FaceErrorScreen(
              session: widget.session,
              failure: result.failure!,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.session.photoPath;

    return Scaffold(
      backgroundColor: GenerateColors.errorScreenBackground,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FlowHeader(
                  title: 'Check Your Photo',
                  height: 64,
                  background: GenerateColors.errorHeaderBackground,
                  blurred: false,
                  titleColor: GenerateColors.headingAlt,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "We couldn't detect a clear face",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 28 / 20,
                            color: GenerateColors.headingAlt,
                          ),
                        ),
                        const SizedBox(height: 7.5),
                        Text(
                          'Please upload a photo where your face is clearly\nvisible and facing th',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 18 / 13,
                            color: GenerateColors.body,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (photo != null) _preview(photo),
                        const SizedBox(height: 16),
                        Center(child: _badge()),
                        const SizedBox(height: 24),
                        _reasons(),
                        const SizedBox(height: 24),
                        _primaryCta(),
                        const SizedBox(height: 12),
                        _secondaryCta(),
                        const SizedBox(height: 24),
                        PrivacyFootnote(
                          noun: widget.session.config.privacyNoun,
                          opacity: 0.70,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_busy)
              const ColoredBox(
                color: Color(0x33000000),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _preview(String path) {
    return Center(
      child: Container(
        width: 192,
        height: 192,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
            BoxShadow(
              color: GenerateColors.errorPreviewGlow,
              blurRadius: 0,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(File(path), fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0x66000000), Color(0x00000000)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: GenerateColors.errorBadgeBackground,
        border: Border.all(color: GenerateColors.errorBadgeBorder),
        borderRadius: BorderRadius.circular(9999),
        boxShadow: GenerateColors.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/generate/icons/err_alert.svg',
            width: 16,
            height: 14,
          ),
          const SizedBox(width: 8),
          Text(
            'Face not detected',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 16 / 12,
              letterSpacing: 0.12,
              color: GenerateColors.errorBadgeContent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reasons() {
    const reasons = [
      'Face is too far away',
      'Photo is too dark or blurry',
      'Face is covered or turned away',
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GenerateColors.errorCardBackground,
        border: Border.all(color: GenerateColors.errorCardBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/generate/icons/err_info.svg',
                width: 13,
                height: 13,
              ),
              const SizedBox(width: 8),
              Text(
                'Possible reasons:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 18 / 13,
                  color: GenerateColors.headingAlt,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < reasons.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                reasons[i],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 18 / 13,
                  color: GenerateColors.body,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _primaryCta() {
    return GestureDetector(
      onTap: () => _retry(camera: false),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: GenerateColors.errorCtaGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: GenerateColors.buttonShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/generate/icons/err_photo.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Choose Another Photo',
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
    );
  }

  Widget _secondaryCta() {
    return GestureDetector(
      onTap: () => _retry(camera: true),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: GenerateColors.outlineButtonBorder,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/generate/icons/err_camera.svg',
              width: 20,
              height: 18,
              colorFilter: const ColorFilter.mode(
                GenerateColors.link,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Try Camera',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 24 / 16,
                color: GenerateColors.link,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
