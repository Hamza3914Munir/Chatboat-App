import 'package:facepix/core/theme/generate_colors.dart';
import 'package:facepix/features/generate/models/generation_session.dart';
import 'package:facepix/features/generate/screens/upload_photo_screen.dart';
import 'package:facepix/features/generate/widgets/flow_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Customize Video` (2299:870) — the video brief form.
class CustomizeVideoScreen extends StatefulWidget {
  const CustomizeVideoScreen({super.key, required this.session});

  final GenerationSession session;

  @override
  State<CustomizeVideoScreen> createState() => _CustomizeVideoScreenState();
}

class _CustomizeVideoScreenState extends State<CustomizeVideoScreen> {
  final _name = TextEditingController();
  final _role = TextEditingController();
  final _background = TextEditingController();
  final _notes = TextEditingController();

  int _purpose = 0;
  int _style = 0;
  int _length = 0;

  static const _purposes = [
    'Job Application',
    'LinkedIn',
    'Portfolio',
    'Personal Profile',
  ];
  static const _styles = ['Professional', 'Friendly', 'Confident'];
  static const _lengths = ['15 sec', '20 sec'];

  @override
  void initState() {
    super.initState();
    _notes.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _role.dispose();
    _background.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _continue() {
    final session = widget.session
      ..fullName = _name.text
      ..professionalRole = _role.text
      ..background = _background.text
      ..videoPurposeIndex = _purpose
      ..presentationStyleIndex = _style
      ..videoLengthIndex = _length
      ..extraNotes = _notes.text;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UploadPhotoScreen(session: session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GenerateColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FlowHeader(title: 'Customize Video'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _styleCard(),
                    const SizedBox(height: 24),
                    Text(
                      'Personalize your intro',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 28 / 22,
                        letterSpacing: -0.22,
                        color: GenerateColors.headingAlt,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add a few details so AI can create a video that sounds like you.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        color: GenerateColors.body,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('About you'),
                    const SizedBox(height: 12),
                    _field('Full Name', 'e.g. Jane Doe', _name),
                    const SizedBox(height: 16),
                    _field('Professional Role', 'e.g. UX Designer', _role),
                    const SizedBox(height: 16),
                    _field(
                      'Education/Background (Optional)',
                      'e.g. Stanford grad, 5 yrs exp',
                      _background,
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('Video purpose'),
                    const SizedBox(height: 12),
                    _chips(
                      _purposes,
                      _purpose,
                      (i) => setState(() => _purpose = i),
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('Presentation style'),
                    const SizedBox(height: 12),
                    _chips(_styles, _style, (i) => setState(() => _style = i)),
                    const SizedBox(height: 24),
                    _sectionTitle('Video length'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (var i = 0; i < _lengths.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _length = i),
                              child: Container(
                                height: 38,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: i == _length
                                      ? const Color(0xFFE2DFFF)
                                      : Colors.white,
                                  border: Border.all(
                                    color: i == _length
                                        ? Colors.transparent
                                        : GenerateColors.styleCardBorder,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _lengths[i],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 20 / 14,
                                    color: i == _length
                                        ? GenerateColors.link
                                        : GenerateColors.body,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    _notesField(),
                    const SizedBox(height: 24),
                    _proTip(),
                  ],
                ),
              ),
            ),
            BottomActionArea(
              privacyNoun: widget.session.config.privacyNoun,
              onContinue: _continue,
              showTip: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _styleCard() {
    final style = widget.session.style;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              style.asset,
              width: 66,
              height: 66,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 24 / 16,
                    color: GenerateColors.headingAlt,
                  ),
                ),
                Text(
                  style.duration?.toLowerCase() ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 18 / 13,
                    color: GenerateColors.body,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Change style',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    color: GenerateColors.link,
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/generate/icons/change_style_arrow.svg',
                  width: 9,
                  height: 9,
                  colorFilter: const ColorFilter.mode(
                    GenerateColors.link,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 24 / 16,
      color: GenerateColors.headingAlt,
    ),
  );

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: 0.12,
      color: GenerateColors.body,
    ),
  );

  Widget _field(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 4),
        Container(
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: GenerateColors.styleCardBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 20.2 / 16,
              color: GenerateColors.headingAlt,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 20.2 / 16,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _chips(List<String> labels, int selected, ValueChanged<int> onTap) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < labels.length; i++)
          GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: i == selected ? const Color(0xFFE2DFFF) : Colors.white,
                border: Border.all(
                  color: i == selected
                      ? Colors.transparent
                      : GenerateColors.styleCardBorder,
                ),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Center(
                widthFactor: 1,
                child: Text(
                  labels[i],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    color: i == selected
                        ? GenerateColors.link
                        : GenerateColors.body,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _notesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label('Anything else? (Optional)'),
            Text(
              '${_notes.text.length}/120',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
                letterSpacing: 0.12,
                color: GenerateColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: GenerateColors.styleCardBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _notes,
            maxLines: 3,
            maxLength: 120,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              height: 24 / 16,
              color: GenerateColors.headingAlt,
            ),
            decoration: InputDecoration(
              isDense: true,
              counterText: '',
              border: InputBorder.none,
              hintText: 'Add specific phrases or tones...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 24 / 16,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _proTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GenerateColors.tipBackground,
        border: Border.all(color: GenerateColors.tipBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pro Tip for Best Results',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 24 / 16,
              color: GenerateColors.headingAlt,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Keep details concise. Our AI works best with',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 18 / 13,
              color: GenerateColors.body,
            ),
          ),
        ],
      ),
    );
  }
}
