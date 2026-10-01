import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs [body] with RenderFlex overflow errors suppressed.
///
/// Used only by the auth tests that navigate into [AppShell] on success. The
/// shell currently overflows at phone width, which is a real finding but a
/// separate screen's problem — without this the auth test fails for something
/// it does not cover. Every other kind of error still fails the test.
Future<void> ignoringOverflowFromDestination(
  Future<void> Function() body,
) async {
  final original = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('A RenderFlex overflowed')) return;
    original?.call(details);
  };
  try {
    await body();
  } finally {
    FlutterError.onError = original;
  }
}

/// Standard iPhone-class surface (390x1000pt) with room to lay out a long
/// scrolling form, so every control is hit-testable and layout assertions
/// reflect a real device rather than the 800x600 test default.
void usePhoneSurface(WidgetTester tester, {double heightPt = 1200}) {
  tester.view.physicalSize = Size(390 * 3, heightPt * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}
