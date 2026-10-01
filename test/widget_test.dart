import 'package:facepix/features/onboarding/onboarding_page.dart';
import 'package:facepix/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Onboarding first page shows title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const FacePixApp());
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    expect(find.text('Perfect for Face'), findsOneWidget);
    expect(find.text('frame Setup!'), findsOneWidget);
  });

  testWidgets('Onboarding page data has four screens', (WidgetTester tester) async {
    expect(onboardingPages.length, 4);
  });
}
