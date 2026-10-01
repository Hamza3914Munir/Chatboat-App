import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/upload_photo_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:facepix/features/generate/widgets/selected_style_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Customize` (2284:682 portrait, 2292:134 ID photo) — background and
/// photo-size pickers.
class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key, required this.session});

  final GenerationSession session;

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  late int _background = widget.session.backgroundIndex;
  late int _size = widget.session.photoSizeIndex;

  void _continue() {
    final session = widget.session
      ..backgroundIndex = _background
      ..photoSizeIndex = _size;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UploadPhotoScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.session.config;
    final noun = config.privacyNoun;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlowHeader(title: 'Customize $noun'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: SelectedStyleSummary(
                        session: widget.session,
                        onChangeStyle: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customize your ${noun.toLowerCase()}',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              height: 30 / 22,
                              color: GenerateColors.headingAlt,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Choose a background and photo size for your final\nimage.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 18 / 13,
                              color: GenerateColors.body,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _sectionHeader(
                      'Background',
                      'Choose a clean background for your professional\n${noun.toLowerCase()}.',
                    ),
                    const SizedBox(height: 12),
                    _backgroundRow(),
                    const SizedBox(height: 24),
                    _sectionHeader(
                      'Photo size',
                      "Choose the format that fits where you'll use your\nphoto.",
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _sizeGrid(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            BottomActionArea(privacyNoun: noun, onContinue: _continue),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String body) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 24 / 16,
            color: GenerateColors.headingAlt,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 18 / 13,
            color: GenerateColors.body,
          ),
        ),
      ],
    ),
  );

  Widget _backgroundRow() {
    return SizedBox(
      // 112 rather than the design's 104 so the two-line "Neutral Beige"
      // label fits without clipping.
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        itemCount: _backgrounds.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _BackgroundSwatch(
          data: _backgrounds[i],
          selected: i == _background,
          onTap: () => setState(() => _background = i),
        ),
      ),
    );
  }

  Widget _sizeGrid() {
    return Column(
      children: [
        for (var row = 0; row * 2 < _sizes.length; row++) ...[
          if (row > 0) const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _sizeCard(row * 2)),
              const SizedBox(width: 12),
              Expanded(child: _sizeCard(row * 2 + 1)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _sizeCard(int i) => _PhotoSizeCard(
    data: _sizes[i],
    selected: i == _size,
    onTap: () => setState(() => _size = i),
  );
}

class _BackgroundData {
  const _BackgroundData({
    required this.label,
    this.color,
    this.asset,
    this.tiled = false,
  });

  final String label;
  final Color? color;
  final String? asset;
  final bool tiled;
}

const _backgrounds = <_BackgroundData>[
  _BackgroundData(
    label: 'Original',
    asset: 'assets/generate/styles/bg_original.png',
  ),
  _BackgroundData(label: 'White', color: Color(0xFFFFFFFF)),
  _BackgroundData(label: 'Light Gray', color: Color(0xFFF2F3F5)),
  _BackgroundData(label: 'Soft Blue', color: Color(0xFFEAF2FF)),
  _BackgroundData(label: 'Neutral\nBeige', color: Color(0xFFF4EFE8)),
  _BackgroundData(
    label: 'Office',
    asset: 'assets/generate/styles/bg_office.png',
    tiled: true,
  ),
];

class _BackgroundSwatch extends StatelessWidget {
  const _BackgroundSwatch({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _BackgroundData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            SizedBox(
              width: 68,
              height: 66,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: data.color ?? const Color(0xFFEDEEF0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? GenerateColors.link
                            : const Color(0xFFE2E2E4),
                        width: selected ? 2 : 1,
                      ),
                      boxShadow: GenerateColors.softShadow,
                      image: data.asset == null
                          ? null
                          : DecorationImage(
                              image: AssetImage(data.asset!),
                              fit: data.tiled ? BoxFit.none : BoxFit.cover,
                              repeat: data.tiled
                                  ? ImageRepeat.repeat
                                  : ImageRepeat.noRepeat,
                              opacity: data.asset!.contains('original')
                                  ? 0.8
                                  : 1,
                            ),
                    ),
                  ),
                  if (selected)
                    Positioned(
                      right: 0,
                      top: -2,
                      child: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: GenerateColors.link,
                          shape: BoxShape.circle,
                          boxShadow: GenerateColors.softShadow,
                        ),
                        child: SvgPicture.asset(
                          'assets/generate/icons/swatch_check.svg',
                          width: 9,
                          height: 7,
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
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                data.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  height: 16 / 12,
                  letterSpacing: 0.12,
                  color: selected ? GenerateColors.link : GenerateColors.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SizeData {
  const _SizeData({
    required this.label,
    this.ratioLabel,
    this.icon,
    required this.boxWidth,
    required this.boxHeight,
    this.recommended = false,
  });

  final String label;
  final String? ratioLabel;
  final String? icon;
  final double boxWidth;
  final double boxHeight;
  final bool recommended;
}

const _sizes = <_SizeData>[
  _SizeData(label: 'Square', ratioLabel: '1:1', boxWidth: 48, boxHeight: 48),
  _SizeData(label: 'Portrait', ratioLabel: '4:5', boxWidth: 40, boxHeight: 48),
  _SizeData(
    label: 'LinkedIn',
    icon: 'assets/generate/icons/size_linkedin.svg',
    boxWidth: 48,
    boxHeight: 48,
    recommended: true,
  ),
  _SizeData(
    label: 'Resume',
    icon: 'assets/generate/icons/size_resume.svg',
    boxWidth: 40,
    boxHeight: 56,
  ),
];

class _PhotoSizeCard extends StatelessWidget {
  const _PhotoSizeCard({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _SizeData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 122,
        margin: const EdgeInsets.only(top: 11),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE2DFFF) : Colors.white,
          border: Border.all(
            color: selected ? GenerateColors.link : const Color(0xFFE2E2E4),
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected ? GenerateColors.softShadow : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (data.icon != null)
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0x1A493EE5) : null,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      data.icon!,
                      width: 20,
                      height: 19,
                      colorFilter: ColorFilter.mode(
                        selected
                            ? GenerateColors.link
                            : GenerateColors.styleCardBorder,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                else
                  Container(
                    width: data.boxWidth,
                    height: data.boxHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: GenerateColors.styleCardBorder,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      data.ratioLabel!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 18 / 13,
                        color: GenerateColors.styleCardBorder,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  data.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                    height: 20 / 14,
                    color: selected
                        ? GenerateColors.link
                        : GenerateColors.headingAlt,
                  ),
                ),
              ],
            ),
            if (data.recommended)
              Positioned(
                top: -11,
                child: Container(
                  height: 23,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: GenerateColors.link,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: GenerateColors.softShadow,
                  ),
                  child: Text(
                    'RECOMMENDED',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 15 / 10,
                      letterSpacing: 0.25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (selected)
              Positioned(
                right: 10,
                top: 9,
                child: SvgPicture.asset(
                  'assets/generate/icons/size_check.svg',
                  width: 13,
                  height: 13,
                  colorFilter: const ColorFilter.mode(
                    GenerateColors.link,
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
