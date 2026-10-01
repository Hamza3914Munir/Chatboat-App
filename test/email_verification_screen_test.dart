import 'package:facepix/features/auth/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Email verification screen shows title and email pill', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EmailVerificationScreen(email: 'test@facepix.ai'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Verify your email'), findsOneWidget);
    expect(find.text('test@facepix.ai'), findsOneWidget);
    expect(find.text("I've Verified My Email"), findsOneWidget);
  });
}
