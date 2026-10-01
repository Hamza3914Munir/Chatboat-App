import 'dart:io';

import 'package:facepix/core/services/face_check_service.dart';
import 'package:facepix/core/services/photo_picker_service.dart';
import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/face_error_screen.dart';
import 'package:facepix/features/generate/screens/generating_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:facepix/features/generate/widgets/selected_style_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Upload photo` (2267:2 and its portrait / ID / video twins).
///
/// The chosen photo goes through the on-device face check before anything
/// else: a photo with no face, several faces or a face too small never
/// reaches generation.
class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key, required this.session});

  final GenerationSession session;

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final _picker = PhotoPickerService();
  final _faceCheck = const FaceCheckService();
  bool _busy = false;

  Future<void> _choose({required bool camera}) async {
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
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => GeneratingScreen(session: widget.session),
          ),
        );
      } else {
        await Navigator.of(context).push(
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
    final config = widget.session.config;

    return Scaffold(
      backgroundColor: GenerateColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FlowHeader(
                  title: 'Upload Photo',
                  height: 70,
                  background: GenerateColors.headerBackground,
                  blurred: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StyleContextCard(
                          session: widget.session,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Add your photo',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 30 / 24,
                            color: GenerateColors.heading,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Choose a clear photo with your face visible.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 19.5 / 13,
                            color: GenerateColors.body,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _dropZone(),
                        const SizedBox(height: 25),
                        _guidelines(),
                        const SizedBox(height: 24),
                        PrivacyFootnote(noun: config.privacyNoun),
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

  Widget _dropZone() {
    final photo = widget.session.photoPath;
    return GestureDetector(
      onTap: () => _choose(camera: false),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0x4D493EE5), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFEAE6F4),
                shape: BoxShape.circle,
              ),
              child: photo == null
                  ? SvgPicture.asset(
                      'assets/generate/icons/upload_cloud.svg',
                      width: 29,
                      height: 21,
                      colorFilter: const ColorFilter.mode(
                        GenerateColors.uploadIcon,
                        BlendMode.srcIn,
                      ),
                    )
                  : ClipOval(
                      child: Image.file(
                        File(photo),
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              photo == null ? 'Tap to upload photo' : 'Tap to choose another',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 24 / 16,
                color: GenerateColors.link,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'JPG, PNG, or HEIC',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 18 / 12,
                color: GenerateColors.body,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: GenerateColors.styleCardBorder,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 16.5 / 11,
                      color: GenerateColors.body,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: GenerateColors.styleCardBorder,
                    height: 1,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _choose(camera: true),
              child: Container(
                width: 163,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: GenerateColors.cameraButtonGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Open camera',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 20 / 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guidelines() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xADF1EEFF),
        border: Border.all(color: const Color(0x1A493EE5)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0x1A493EE5),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/generate/icons/guide_lighting.svg',
                  width: 22,
                  height: 22,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Pro Tips for Best Results',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 24 / 17,
                  color: GenerateColors.heading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < _tips.length; i++) ...[
            if (i > 0) const SizedBox(height: 24),
            _GuidelineRow(data: _tips[i]),
          ],
        ],
      ),
    );
  }
}

class _Tip {
  const _Tip(this.title, this.body, this.icon);
  final String title;
  final String body;
  final String icon;
}

const _tips = <_Tip>[
  _Tip(
    'Good lighting',
    'Use even lighting and avoid harsh shadows.',
    'assets/generate/icons/guide_lighting.svg',
  ),
  _Tip(
    'Face the camera',
    'Look directly at the camera.',
    'assets/generate/icons/guide_face.svg',
  ),
  _Tip(
    'One visible face',
    'Make sure only one face is visible.',
    'assets/generate/icons/guide_single.svg',
  ),
];

class _GuidelineRow extends StatelessWidget {
  const _GuidelineRow({required this.data});

  final _Tip data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0x1A493EE5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(data.icon, width: 22, height: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 19.5 / 12,
                  color: GenerateColors.body,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                data.body,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 19.5 / 12,
                  color: GenerateColors.body,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
