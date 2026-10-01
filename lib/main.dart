import 'package:device_preview/device_preview.dart';
import 'package:facepix/app/app_bootstrap.dart';
import 'package:facepix/preview/screen_preview_policy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: ScreenPreviewPolicy.enabled,
      defaultDevice: Devices.ios.iPhone13,
      builder: (context) => const FacePixApp(),
    ),
  );
}

class FacePixApp extends StatelessWidget {
  const FacePixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FacePix',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const AppBootstrap(),
    );
  }
}
