import 'package:flutter/foundation.dart';

/// Enables the [`device_preview`](https://pub.dev/packages/device_preview) package.
///
/// On web (debug and release), the Device preview sidebar and device frame are
/// shown. On iOS/Android native builds, preview is off and the app runs normally.
abstract final class ScreenPreviewPolicy {
  static bool get enabled => kIsWeb;
}
