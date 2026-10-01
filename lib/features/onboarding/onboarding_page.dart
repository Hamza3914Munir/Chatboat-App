import 'package:facepix/core/theme/app_colors.dart';
import 'package:facepix/features/onboarding/onboarding_page_data.dart';
import 'package:facepix/features/onboarding/widgets/onboarding_next_button.dart';
import 'package:facepix/features/onboarding/widgets/onboarding_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.data,
    required this.pageIndex,
    required this.pageCount,
    required this.onNext,
  });

  final OnboardingPageData data;
  final int pageIndex;
  final int pageCount;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: data.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 65,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    data.illustrationAsset,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: data.indicatorBottomPadding),
              child: OnboardingPageIndicator(
                pageCount: pageCount,
                currentIndex: pageIndex,
                activeColor: data.indicatorActiveColor,
                inactiveColor: data.indicatorInactiveColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(28, 0, 28, data.bottomPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: data.titleLines
                          .map(
                            (line) => Text(
                              line,
                              style: GoogleFonts.poppins(
                                fontSize: data.titleFontSize,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                                color: Colors.white,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OnboardingNextButton(
                    onPressed: onNext,
                    gradient: data.buttonGradient,
                    gradientBegin: data.buttonGradientBegin,
                    gradientEnd: data.buttonGradientEnd,
                    solidColor: data.buttonSolidColor,
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

List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    backgroundColor: AppColors.onboardingYellow,
    illustrationAsset: 'assets/onboarding/onboarding_1.png',
    titleLines: ['Perfect for Face', 'frame Setup!'],
    indicatorActiveColor: AppColors.onboardingPurpleSolid,
    indicatorInactiveColor: AppColors.indicatorInactiveWhite,
    buttonSolidColor: AppColors.onboardingPurpleSolid,
  ),
  OnboardingPageData(
    backgroundColor: AppColors.onboardingCoral,
    illustrationAsset: 'assets/onboarding/onboarding_2.png',
    titleLines: ['Make every shot', 'better!'],
    indicatorActiveColor: AppColors.onboardingPurpleSolid,
    indicatorInactiveColor: AppColors.indicatorInactiveBlueViolet,
    buttonGradient: AppColors.onboardingBluePurpleGradient,
    buttonGradientBegin: Alignment.centerLeft,
    buttonGradientEnd: Alignment.centerRight,
  ),
  OnboardingPageData(
    backgroundColor: AppColors.onboardingPurple,
    illustrationAsset: 'assets/onboarding/onboarding_3.png',
    titleLines: ['Create fun', 'face edits!'],
    indicatorActiveColor: AppColors.onboardingYellowAccent,
    indicatorInactiveColor: AppColors.indicatorInactiveTan,
    buttonSolidColor: AppColors.onboardingYellowAccent,
  ),
  OnboardingPageData(
    backgroundColor: AppColors.onboardingPink,
    illustrationAsset: 'assets/onboarding/onboarding_4.png',
    titleLines: ['Enhance photos', 'and videos!'],
    indicatorActiveColor: AppColors.onboardingYellowAccent,
    indicatorInactiveColor: AppColors.indicatorInactiveYellowMuted,
    buttonSolidColor: AppColors.onboardingYellowAccent,
  ),
];
