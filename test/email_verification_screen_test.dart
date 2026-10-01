import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/features/auth/email_verification_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_support.dart';

Future<void> pumpVerification(
  WidgetTester tester, {
  String? email = 'test@facepix.ai',
}) async {
  usePhoneSurface(tester);
  await tester.pumpWidget(
    MaterialApp(home: EmailVerificationScreen(email: email)),
  );
  await tester.pumpAndSettle();
}

VoidCallback? resendTap(WidgetTester tester) {
  return tester
      .widget<InkWell>(
        find
            .descendant(
              of: find.byType(SecondaryOutlinedButton),
              matching: find.byType(InkWell),
            )
            .first,
      )
      .onTap;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows the Figma copy and the email pill', (tester) async {
    await pumpVerification(tester);
    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.text('test@facepix.ai'), findsOneWidget);
    expect(find.text("I've Verified My Email"), findsOneWidget);
  });

  testWidgets('falls back to the stored signup email', (tester) async {
    SharedPreferences.setMockInitialValues({'signup_email': 'stored@x.com'});
    await pumpVerification(tester, email: null);
    expect(find.text('stored@x.com'), findsOneWidget);
  });

  testWidgets('confirming verification persists the flag', (tester) async {
    await pumpVerification(tester);
    expect(await AuthFlowPreferences.isEmailVerified(), isFalse);

    await ignoringOverflowFromDestination(() async {
      await tester.tap(find.text("I've Verified My Email"));
      await tester.pumpAndSettle();
    });

    expect(await AuthFlowPreferences.isEmailVerified(), isTrue);
  });

  testWidgets('resend confirms and starts a cooldown', (tester) async {
    await pumpVerification(tester);
    expect(resendTap(tester), isNotNull);

    // The regression this guards: resend used to be `onPressed: () {}`.
    await tester.tap(find.text('Resend Verification Email'));
    await tester.pump();

    expect(
      find.text('Verification email sent again to test@facepix.ai.'),
      findsOneWidget,
    );
    expect(find.text('Resend in 30s'), findsOneWidget);
    expect(resendTap(tester), isNull);

    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    expect(find.text('Resend Verification Email'), findsOneWidget);
    expect(resendTap(tester), isNotNull);
  });
}
