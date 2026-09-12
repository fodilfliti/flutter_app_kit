import 'package:flutter/material.dart';
import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import 'helpers/test_failure_text.dart';

void main() {
  testWidgets('showFailure skips CancelledFailure and null', (tester) async {
    final key = GlobalKey<ScaffoldMessengerState>();
    var mapped = 0;
    final notices = MaterialNotices(
      messengerKey: key,
      failureText: (failure) {
        mapped++;
        return testFailureText(failure);
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: key,
        home: const Scaffold(body: SizedBox.shrink()),
      ),
    );

    notices.showFailure(const CancelledFailure());
    notices.showFailure(null);
    await tester.pump();

    expect(mapped, 0);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('showFailure shows others via failureText', (tester) async {
    final key = GlobalKey<ScaffoldMessengerState>();
    final notices = MaterialNotices(
      messengerKey: key,
      failureText: testFailureText,
    );

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: key,
        home: const Scaffold(body: SizedBox.shrink()),
      ),
    );

    notices.showFailure(const NetworkFailure());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('mapped:NetworkFailure'), findsOneWidget);
  });

  testWidgets('success shows a snackbar', (tester) async {
    final key = GlobalKey<ScaffoldMessengerState>();
    final notices = MaterialNotices(
      messengerKey: key,
      failureText: testFailureText,
    );

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: key,
        home: const Scaffold(body: SizedBox.shrink()),
      ),
    );

    notices.success('Saved');
    await tester.pump();

    expect(find.text('Saved'), findsOneWidget);
  });
}
