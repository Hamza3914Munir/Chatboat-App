import 'package:facepix/core/preferences/onboarding_preferences.dart';
import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:facepix/features/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    final lastIndex = onboardingPages.length - 1;
    if (_currentPage < lastIndex) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }

    await OnboardingPreferences.setCompleted(true);
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const CreateAccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingPages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          return OnboardingPage(
            data: onboardingPages[index],
            pageIndex: index,
            pageCount: onboardingPages.length,
            onNext: _onNext,
          );
        },
      ),
    );
  }
}
