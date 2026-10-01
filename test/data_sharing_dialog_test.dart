import 'package:facepix/features/auth/widgets/data_sharing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Data sharing dialog shows allow and not now buttons', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => showDataSharingDialog(context),
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Allow & Continue'), findsOneWidget);
    expect(find.text('Not Now'), findsOneWidget);
    expect(find.text('Help us improve your AI experience'), findsOneWidget);
  });
}
