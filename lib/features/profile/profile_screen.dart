import 'package:facepix/core/theme/profile_colors.dart';
import 'package:facepix/features/home/widgets/home_app_bar.dart';
import 'package:facepix/features/profile/widgets/profile_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `Profile` (2312:95) — 375x1406.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ProfileColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeAppBar(credits: credits),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _accountCard(),
                  const SizedBox(height: 24),
                  _creditsCard(),
                  const SizedBox(height: 24),
                  _sectionHeading('ACCOUNT'),
                  const SizedBox(height: 12),
                  ProfileSectionCard(
                    children: [
                      ProfileRow(
                        title: 'Personal Information',
                        subtitle: 'Manage your account details',
                        iconAsset:
                            'assets/profile/icons/icon_personal_info.svg',
                        onTap: () {},
                      ),
                      ProfileRow(
                        title: 'Email & Security',
                        subtitle: 'Password and account security',
                        iconAsset:
                            'assets/profile/icons/icon_email_security.svg',
                        iconWidth: 13,
                        iconHeight: 18,
                        onTap: () {},
                      ),
                      ProfileRow(
                        title: 'Account Status',
                        subtitle: 'Verified account',
                        iconAsset:
                            'assets/profile/icons/icon_account_status.svg',
                        iconWidth: 13,
                        iconHeight: 17,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionHeading('PRIVACY & DATA'),
                  const SizedBox(height: 12),
                  ProfileSectionCard(
                    children: [
                      ProfileRow(
                        title: 'AI Data Sharing',
                        subtitle:
                            'Control how your data is used by AI\nservices',
                        iconAsset: 'assets/profile/icons/icon_ai_data.svg',
                        iconWidth: 15,
                        iconHeight: 15,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionHeading('LEGAL'),
                  const SizedBox(height: 12),
                  ProfileSectionCard(
                    children: [
                      ProfileRow(
                        title: 'Privacy Policy',
                        trailingAsset: 'assets/profile/icons/icon_external.svg',
                        trailingWidth: 15,
                        trailingHeight: 15,
                        onTap: () {},
                      ),
                      ProfileRow(
                        title: 'Terms of Service',
                        trailingAsset: 'assets/profile/icons/icon_external.svg',
                        trailingWidth: 15,
                        trailingHeight: 15,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  ProfileSectionCard(
                    children: [
                      ProfileRow(
                        title: 'Log out',
                        trailingAsset: 'assets/profile/icons/icon_logout.svg',
                        trailingWidth: 18,
                        trailingHeight: 18,
                        onTap: () {},
                      ),
                      ProfileRow(
                        title: 'Delete Account',
                        titleColor: ProfileColors.danger,
                        trailingAsset:
                            'assets/profile/icons/icon_delete_account.svg',
                        trailingWidth: 16,
                        trailingHeight: 18,
                        trailingColor: ProfileColors.danger,
                        trailingOpacity: 0.70,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 14 / 12,
        letterSpacing: 0.6,
        color: ProfileColors.muted,
      ),
    ),
  );

  Widget _accountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProfileColors.cardBackground,
        border: Border.all(color: ProfileColors.cardBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow: ProfileColors.sectionCardShadow,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ProfileColors.avatarRing,
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile/avatar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 58,
                  top: 50,
                  child: Container(
                    width: 22,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ProfileColors.cardBorder),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: const [
                        BoxShadow(
                          color: ProfileColors.cardShadow,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/profile/icons/icon_edit_avatar.svg',
                      width: 12,
                      height: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'John Doe',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              color: ProfileColors.name,
            ),
          ),
          Text(
            'Johndoe@example.com',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: ProfileColors.muted,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: ProfileColors.verifiedPillBackground,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/profile/icons/icon_verified.svg',
                  width: 12,
                  height: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  'Email verified',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 14 / 12,
                    letterSpacing: 0.36,
                    color: ProfileColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditsCard() {
    return Container(
      height: 76,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProfileColors.cardBackground,
        border: Border.all(color: ProfileColors.cardBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow: ProfileColors.sectionCardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Free Plan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 24 / 16,
                  color: ProfileColors.rowTitle,
                ),
              ),
              const SizedBox(height: 3.5),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/profile/icons/icon_credits.svg',
                    width: 13,
                    height: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$credits Credits remaining',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 14 / 12,
                      letterSpacing: 0.36,
                      color: ProfileColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: ProfileColors.upgradeGradient,
              borderRadius: BorderRadius.circular(8),
              boxShadow: ProfileColors.buttonShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Upgrade to Pro',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 14 / 12,
                    letterSpacing: 0.36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/profile/icons/icon_upgrade_arrow.svg',
                  width: 9,
                  height: 9,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
