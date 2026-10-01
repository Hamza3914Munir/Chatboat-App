import 'package:facepix/features/auth/forgot_password_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpForgot(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1170, 3000);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));
  await tester.pumpAndSettle();
}

VoidCallback? sendButtonTap(WidgetTester tester) {
  return tester
      .widget<InkWell>(
        find
            .descendant(
              of: find.byType(GradientAuthButton),
              matching: find.byType(InkWell),
            )
            .first,
      )
      .onTap;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows the Figma copy', (tester) async {
    await pumpForgot(tester);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
  });

  testWidgets('an empty email is rejected and nothing is sent', (tester) async {
    await pumpForgot(tester);
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.textContaining('a reset link is on its way'), findsNothing);
  });

  testWidgets('a malformed email is rejected', (tester) async {
    await pumpForgot(tester);
    await tester.enterText(find.byType(TextField).first, 'nope');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.textContaining('a reset link is on its way'), findsNothing);
  });

  testWidgets('a valid email confirms and starts the resend cooldown', (
    tester,
  ) async {
    await pumpForgot(tester);
    await tester.enterText(find.byType(TextField).first, 'hamza@facepix.ai');
    await tester.pumpAndSettle();

    // The regression this guards: the button used to be `onPressed: () {}`,
    // so a tap produced no confirmation of any kind.
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();

    expect(
      find.textContaining('If an account exists for hamza@facepix.ai'),
      findsOneWidget,
    );
    expect(find.text('Resend in 30s'), findsOneWidget);
    expect(sendButtonTap(tester), isNull, reason: 'blocked during cooldown');
  });

  testWidgets('the cooldown counts down and re-enables the button', (
    tester,
  ) async {
    await pumpForgot(tester);
    await tester.enterText(find.byType(TextField).first, 'hamza@facepix.ai');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Resend in 29s'), findsOneWidget);

    for (var i = 0; i < 29; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    expect(find.text('Resend Reset Link'), findsOneWidget);
    expect(sendButtonTap(tester), isNotNull);
  });
}
