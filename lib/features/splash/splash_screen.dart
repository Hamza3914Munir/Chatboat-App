import 'package:facepix/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Image(
            image: AssetImage('assets/branding/facepix_logo_full.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
