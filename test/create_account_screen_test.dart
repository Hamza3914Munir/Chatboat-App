import 'package:facepix/core/preferences/registration_preferences.dart';
import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_support.dart';

/// A surface tall enough to lay the whole scrolling form out, so every control
/// is hit-testable. At the default 800x600 the submit button sits off-screen
/// and taps silently miss it.
Future<void> pumpSignup(WidgetTester tester) async {
  usePhoneSurface(tester, heightPt: 1400);
  await tester.pumpWidget(const MaterialApp(home: CreateAccountScreen()));
  await tester.pumpAndSettle();
}

/// Ticks the consent box the way a user does.
///
/// `warnIfMissed` is off because the [Checkbox] itself is deliberately
/// wrapped in an `IgnorePointer`: the whole row owns the gesture so the target
/// is big enough to hit. The tap lands on the row behind it, which is the
/// behaviour under test.
Future<void> acceptTerms(WidgetTester tester) async {
  await tester.tap(find.byType(Checkbox), warnIfMissed: false);
  await tester.pumpAndSettle();
}

Future<void> fillValidForm(WidgetTester tester) async {
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), 'Hamza Munir');
  await tester.enterText(fields.at(1), 'hamza@facepix.ai');
  await tester.enterText(fields.at(2), 'supersecret1');
  await tester.enterText(fields.at(3), 'supersecret1');
  await tester.pumpAndSettle();
}

bool get _onSignup => find.text('Create your account').evaluate().isNotEmpty;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows the Figma copy', (tester) async {
    await pumpSignup(tester);
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.textContaining('Start creating amazing photos'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('submit is disabled until the terms box is ticked', (
    tester,
  ) async {
    await pumpSignup(tester);

    final inkWell = find.descendant(
      of: find.byType(GradientAuthButton),
      matching: find.byType(InkWell),
    );
    // A null onTap is what makes it genuinely disabled: no ripple, and
    // reported as disabled rather than actionable to assistive tech.
    expect(tester.widget<InkWell>(inkWell).onTap, isNull);

    await acceptTerms(tester);
    expect(tester.widget<InkWell>(inkWell).onTap, isNotNull);
  });

  testWidgets('tapping the terms sentence toggles the checkbox', (
    tester,
  ) async {
    await pumpSignup(tester);
    bool checked() => tester.widget<Checkbox>(find.byType(Checkbox)).value!;

    expect(checked(), isFalse);
    await tester.tap(find.textContaining('I agree to the', findRichText: true));
    await tester.pumpAndSettle();
    expect(checked(), isTrue);
  });

  testWidgets('an empty form is rejected and never persisted', (tester) async {
    await pumpSignup(tester);
    await acceptTerms(tester);
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(_onSignup, isTrue, reason: 'must not navigate away');
    expect(find.text('Enter your full name.'), findsOneWidget);
    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter a password.'), findsOneWidget);
    expect(await RegistrationPreferences.isCompleted(), isFalse);
  });

  testWidgets('a malformed email is rejected', (tester) async {
    await pumpSignup(tester);
    await tester.enterText(find.byType(TextField).at(1), 'not-an-email');
    await acceptTerms(tester);
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(_onSignup, isTrue);
    expect(find.text('Enter a valid email address.'), findsOneWidget);
  });

  testWidgets('a password under 8 characters is rejected', (tester) async {
    await pumpSignup(tester);
    await tester.enterText(find.byType(TextField).at(2), 'abc');
    await acceptTerms(tester);
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(_onSignup, isTrue);
    expect(find.text('Use at least 8 characters.'), findsOneWidget);
  });

  testWidgets('a mismatched confirmation is rejected', (tester) async {
    await pumpSignup(tester);
    await fillValidForm(tester);
    await tester.enterText(find.byType(TextField).at(3), 'something-else');
    await acceptTerms(tester);
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(_onSignup, isTrue);
    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  testWidgets('a valid form advances and stores the account', (tester) async {
    await pumpSignup(tester);
    await fillValidForm(tester);
    await acceptTerms(tester);
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(_onSignup, isFalse);
    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.text('hamza@facepix.ai'), findsOneWidget);
    expect(await RegistrationPreferences.isCompleted(), isTrue);
  });

  testWidgets('password visibility toggles independently per field', (
    tester,
  ) async {
    await pumpSignup(tester);
    TextField field(int i) => tester.widget<TextField>(
      find.byType(TextField).at(i),
    );

    expect(field(2).obscureText, isTrue);
    expect(field(3).obscureText, isTrue);

    await tester.tap(find.byType(PasswordVisibilityToggle).first);
    await tester.pumpAndSettle();

    expect(field(2).obscureText, isFalse);
    expect(field(3).obscureText, isTrue, reason: 'confirm must stay masked');
  });

  testWidgets('fields carry autofill hints and a keyboard flow', (
    tester,
  ) async {
    await pumpSignup(tester);
    final fields = find
        .byType(TextField)
        .evaluate()
        .map((e) => e.widget as TextField)
        .toList();

    expect(fields[0].autofillHints, contains(AutofillHints.name));
    expect(fields[1].autofillHints, contains(AutofillHints.email));
    expect(fields[2].autofillHints, contains(AutofillHints.newPassword));
    expect(fields[0].textInputAction, TextInputAction.next);
    expect(fields[3].textInputAction, TextInputAction.done);
  });
}
