import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/core/preferences/registration_preferences.dart';
import 'package:facepix/features/auth/login_screen.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_support.dart';

/// Phone-width surface (390pt), so layout assertions reflect a real device.
Future<void> pumpLogin(WidgetTester tester) async {
  usePhoneSurface(tester);
  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  await tester.pumpAndSettle();
}



bool get _onLogin => find.text('Welcome back').evaluate().isNotEmpty;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows the Figma copy', (tester) async {
    await pumpLogin(tester);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('an empty form is rejected', (tester) async {
    await pumpLogin(tester);
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(_onLogin, isTrue);
    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
  });

  testWidgets('a malformed email is rejected', (tester) async {
    await pumpLogin(tester);
    await tester.enterText(find.byType(TextField).at(0), 'nope');
    await tester.enterText(find.byType(TextField).at(1), 'whatever');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(_onLogin, isTrue);
    expect(find.text('Enter a valid email address.'), findsOneWidget);
  });

  testWidgets('login does not apply the sign-up password length rule', (
    tester,
  ) async {
    await pumpLogin(tester);
    await tester.enterText(find.byType(TextField).at(0), 'hamza@facepix.ai');
    await tester.enterText(find.byType(TextField).at(1), 'short');
    await tester.pumpAndSettle();

    expect(find.text('Use at least 8 characters.'), findsNothing);
  });

  testWidgets('a successful login persists the session', (tester) async {
    await pumpLogin(tester);
    await tester.enterText(find.byType(TextField).at(0), 'hamza@facepix.ai');
    await tester.enterText(find.byType(TextField).at(1), 'supersecret1');
    await tester.pumpAndSettle();
    await ignoringOverflowFromDestination(() async {
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();
    });

    // The regression this guards: the screen used to reach the shell without
    // writing anything, so AppBootstrap sent the user back to Create Account
    // on the next launch.
    expect(await RegistrationPreferences.isCompleted(), isTrue);
    expect(await AuthFlowPreferences.isEmailVerified(), isTrue);
    expect(await AuthFlowPreferences.getSignupEmail(), 'hamza@facepix.ai');
    expect(_onLogin, isFalse);
  });

  testWidgets('password visibility toggle flips the field', (tester) async {
    await pumpLogin(tester);
    TextField pw() => tester.widget<TextField>(find.byType(TextField).at(1));

    expect(pw().obscureText, isTrue);
    await tester.tap(find.byType(PasswordVisibilityToggle));
    await tester.pumpAndSettle();
    expect(pw().obscureText, isFalse);
  });

  testWidgets('credentials carry autofill hints', (tester) async {
    await pumpLogin(tester);
    final fields = find
        .byType(TextField)
        .evaluate()
        .map((e) => e.widget as TextField)
        .toList();

    expect(fields[0].autofillHints, contains(AutofillHints.username));
    expect(fields[1].autofillHints, contains(AutofillHints.password));
  });
}
