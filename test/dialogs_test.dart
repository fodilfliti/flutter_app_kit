import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:flutter_test/flutter_test.dart';

const _texts = SignInPromptTexts(
  title: 'Sign in',
  message: 'Sign in to continue',
  signInLabel: 'Go',
  cancelLabel: 'Later',
);

Future<GlobalKey<NavigatorState>> _pumpApp(
  WidgetTester tester, {
  Size size = const Size(1400, 900),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final key = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: key,
      home: const Scaffold(body: SizedBox.shrink()),
    ),
  );
  return key;
}

void main() {
  testWidgets('showAppDialog caps width on wide screens', (tester) async {
    final key = await _pumpApp(tester);
    final dialogs = AppDialogs(navigatorKey: key);

    unawaited(
      dialogs.dialog<void>(
        (_) => const SizedBox(width: 2000, height: 50, child: Text('body')),
        maxWidth: 400,
        showClose: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('body'), findsOneWidget);
    expect(tester.getSize(find.text('body')).width, lessThanOrEqualTo(400));
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    expect(find.text('body'), findsNothing);
  });

  testWidgets('confirm returns true / false', (tester) async {
    final key = await _pumpApp(tester);
    final dialogs = AppDialogs(navigatorKey: key);

    final yes = dialogs.confirm(
      title: 'Delete?',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      destructive: true,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(await yes, isTrue);

    final no = dialogs.confirm(
      title: 'Delete?',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await no, isFalse);
  });

  testWidgets('sheet opens and returns a value', (tester) async {
    final key = await _pumpApp(tester);
    final dialogs = AppDialogs(navigatorKey: key);

    final result = dialogs.sheet<int>(
      (context) => TextButton(
        onPressed: () => Navigator.of(context).pop(7),
        child: const Text('pick'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('pick'));
    await tester.pumpAndSettle();
    expect(await result, 7);
  });

  group('requireSignIn', () {
    testWidgets('signed in → true without dialog', (tester) async {
      final key = await _pumpApp(tester);
      final ok = await AppDialogs(navigatorKey: key).requireSignIn(
        isSignedIn: () => true,
        openSignIn: () => fail('should not open'),
        texts: _texts,
      );
      expect(ok, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('cancel → false', (tester) async {
      final key = await _pumpApp(tester);
      final result = AppDialogs(navigatorKey: key).requireSignIn(
        isSignedIn: () => false,
        openSignIn: () => fail('should not open'),
        texts: _texts,
      );
      await tester.pumpAndSettle();
      expect(find.text('Sign in to continue'), findsOneWidget);
      await tester.tap(find.text('Later'));
      await tester.pumpAndSettle();
      expect(await result, isFalse);
    });

    testWidgets('sign in → opens flow then re-checks session', (tester) async {
      final key = await _pumpApp(tester);
      var signedIn = false;
      final result = AppDialogs(navigatorKey: key).requireSignIn(
        isSignedIn: () => signedIn,
        openSignIn: () async => signedIn = true,
        texts: _texts,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(await result, isTrue);
    });
  });

  test('no navigator mounted → null / false', () async {
    final dialogs = AppDialogs(navigatorKey: GlobalKey<NavigatorState>());
    expect(await dialogs.dialog<int>((_) => const SizedBox()), isNull);
    expect(
      await dialogs.confirm(title: 't', confirmLabel: 'y', cancelLabel: 'n'),
      isFalse,
    );
  });
}
