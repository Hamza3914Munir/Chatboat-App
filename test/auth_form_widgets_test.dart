import 'dart:ui' show Tristate;

import 'package:facepix/core/validation/auth_validators.dart';
import 'package:facepix/features/auth/widgets/auth_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpField(
  WidgetTester tester, {
  String? Function(String?)? validator,
  String? helperText,
  Widget? suffix,
  GlobalKey<FormState>? formKey,
  TextEditingController? controller,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AuthTextField(
              label: 'Password',
              hint: '••••••••',
              leadingIconAsset: 'assets/auth/icon_lock.svg',
              controller: controller ?? TextEditingController(),
              validator: validator,
              helperText: helperText,
              suffix: suffix,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('AuthTextField geometry', () {
    testWidgets('field box stays exactly 56 high', (tester) async {
      await pumpField(tester);
      expect(tester.getSize(find.byType(TextField)).height, 56.0);
    });

    testWidgets('leading icon sits 16 from the left edge at 16x16', (
      tester,
    ) async {
      await pumpField(tester);
      final icon = find.byType(SvgPicture).first;
      final fieldLeft = tester.getTopLeft(find.byType(TextField)).dx;

      expect(tester.getTopLeft(icon).dx - fieldLeft, 16.0);
      // Height is the fixed dimension; width follows the asset's aspect
      // ratio, so it can come out narrower than the 16 requested.
      expect(tester.getSize(icon).height, 16.0);
      expect(tester.getSize(icon).width, lessThanOrEqualTo(16.0));
    });

    testWidgets(
      'enlarging the eye toggle to 48x48 does not move the icon it draws',
      (tester) async {
        await pumpField(
          tester,
          suffix: PasswordVisibilityToggle(visible: false, onToggle: () {}),
        );

        final toggle = find.byType(PasswordVisibilityToggle);
        expect(
          tester.getSize(toggle),
          const Size(kMinTapTarget, kMinTapTarget),
          reason: 'touch target must meet the 48px minimum',
        );

        // Before the fix the icon was an InkWell with 4px padding pinned at
        // right: 16, which put its centre ~27.8px in from the field edge.
        // The 48px box is inset by 4 to land the icon on that same pixel.
        final icon = find.descendant(
          of: toggle,
          matching: find.byType(SvgPicture),
        );
        final fieldRight = tester.getBottomRight(find.byType(TextField)).dx;
        final iconCentre = tester.getCenter(icon).dx;
        expect(fieldRight - iconCentre, closeTo(27.8, 1.0));
      },
    );
  });

  group('AuthTextField validation', () {
    testWidgets('helper text shows until an error replaces it', (tester) async {
      final formKey = GlobalKey<FormState>();
      await pumpField(
        tester,
        formKey: formKey,
        validator: AuthValidators.password,
        helperText: 'Use at least 8 characters.',
      );

      expect(find.text('Use at least 8 characters.'), findsOneWidget);

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Enter a password.'), findsOneWidget);
      expect(
        find.text('Use at least 8 characters.'),
        findsNothing,
        reason: 'the error replaces the helper rather than stacking under it',
      );
    });

    testWidgets('typing re-validates without a submit', (tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();
      await pumpField(
        tester,
        formKey: formKey,
        controller: controller,
        validator: AuthValidators.password,
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('Enter a password.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pumpAndSettle();
      expect(find.text('Use at least 8 characters.'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'longenough1');
      await tester.pumpAndSettle();
      expect(find.textContaining('at least'), findsNothing);
    });
  });

  group('GradientAuthButton', () {
    Future<void> pumpButton(WidgetTester tester, {VoidCallback? onPressed}) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientAuthButton(label: 'Continue', onPressed: onPressed),
          ),
        ),
      );
    }

    testWidgets('a null callback disables tap and ripple', (tester) async {
      await pumpButton(tester);
      final ink = tester.widget<InkWell>(find.byType(InkWell));
      expect(ink.onTap, isNull);
    });

    testWidgets('a null callback reports disabled to screen readers', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpButton(tester);

      final node = tester.getSemantics(find.byType(GradientAuthButton));
      // isFalse, not none: the node declares that it *has* an enabled state
      // and that the state is off. `none` would mean it never told assistive
      // tech anything — which is what the old fake-disabled button did.
      expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      handle.dispose();
    });

    testWidgets('an enabled button fires and reads as enabled', (tester) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await pumpButton(tester, onPressed: () => taps++);

      final node = tester.getSemantics(find.byType(GradientAuthButton));
      expect(node.flagsCollection.isEnabled, Tristate.isTrue);

      await tester.tap(find.byType(GradientAuthButton));
      await tester.pumpAndSettle();
      expect(taps, 1);
      handle.dispose();
    });

    testWidgets('busy blocks input and shows a spinner', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientAuthButton(
              label: 'Continue',
              busy: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
    });
  });
}
