import 'package:facepix/features/auth/create_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Create account screen shows Figma copy', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CreateAccountScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.textContaining('Start creating amazing photos'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
