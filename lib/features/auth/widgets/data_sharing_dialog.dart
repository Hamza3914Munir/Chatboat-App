import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/core/theme/auth_colors.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showDataSharingDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white.withValues(alpha: 0.94),
    builder: (context) => const DataSharingDialog(),
  );
}

class DataSharingDialog extends StatelessWidget {
  const DataSharingDialog({super.key});

  Future<void> _dismiss(BuildContext context) async {
    await AuthFlowPreferences.setDataSharingAcknowledged(true);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AuthColors.dataSharingCardBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 8),
              blurRadius: 32,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AuthColors.dataSharingScrim),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AuthColors.dataSharingIconBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset(
                          'assets/auth/data_sharing_sparkle.svg',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Help us improve your AI experience',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 28 / 22,
                        color: AuthColors.titleDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share anonymized usage data so we can personalize '
                      'recommendations and improve AI results for you.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        color: AuthColors.subtitle,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SharingSectionCard(
                      iconAsset: 'assets/auth/data_sharing_photo.svg',
                      title: 'Photo & video edits',
                      subtitle: 'How you use AI editing tools',
                    ),
                    const SizedBox(height: 12),
                    _SharingSectionCard(
                      iconAsset: 'assets/auth/data_sharing_sliders.svg',
                      title: 'Preferences & settings',
                      subtitle: 'Your style and filter choices',
                    ),
                    const SizedBox(height: 12),
                    _HistorySectionCard(),
                    const SizedBox(height: 24),
                    GradientAuthButton(
                      label: 'Allow & Continue',
                      onPressed: () => _dismiss(context),
                      borderRadius: 12,
                      verticalPadding: 16,
                      trailingIconAsset: 'assets/auth/icon_chevron_small.svg',
                    ),
                    const SizedBox(height: 12),
                    SecondaryOutlinedButton(
                      label: 'Not Now',
                      onPressed: () => _dismiss(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can change this anytime in Settings.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AuthColors.subtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SharingSectionCard extends StatelessWidget {
  const _SharingSectionCard({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });

  final String iconAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AuthColors.dataSharingSectionBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuthColors.dataSharingSectionBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SvgPicture.asset(iconAsset, width: 24, height: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AuthColors.label,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AuthColors.subtitle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistorySectionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AuthColors.dataSharingHistoryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AuthColors.dataSharingHistoryBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/auth/data_sharing_history.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit history',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AuthColors.label,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Anonymized patterns from past edits',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AuthColors.subtitle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
