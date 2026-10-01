import 'package:facepix/preview/screen_preview_policy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ScreenPreviewPolicy enables device_preview only on web', () {
    expect(ScreenPreviewPolicy.enabled, kIsWeb);
  });
}
