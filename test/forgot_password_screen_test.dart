import 'package:facepix/features/auth/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Forgot password screen shows title and send reset link', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ForgotPasswordScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
  });
}
