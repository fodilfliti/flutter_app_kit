import 'package:flutter/material.dart';
import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/recording_reporter.dart';
import 'helpers/test_failure_text.dart';

void main() {
  setUp(debugResetBootstrap);

  tearDown(debugResetBootstrap);

  test('bootstrap with fakes completes without network', () async {
    var firebase = 0;
    var supabase = 0;
    final reporter = RecordingReporter();

    final result = await bootstrap(
      AppConfig(
        failureText: testFailureText,
        flavor: AppFlavor.staging,
        loadEnv: false,
        envValues: const {'API_URL': 'https://example.invalid'},
        wireErrorHandlers: false,
        reporter: reporter,
        sessionStore: MemorySecureSessionStore(),
        prefs: MemorySharedPrefsStore(),
        initFirebase: () async {
          firebase++;
        },
        initSupabase: () async {
          supabase++;
        },
      ),
    );

    expect(result.flavor, AppFlavor.staging);
    expect(result.env.get('API_URL'), 'https://example.invalid');
    expect(result.notices, isA<MaterialNotices>());
    expect(result.messengerKey, isA<GlobalKey<ScaffoldMessengerState>>());
    expect(firebase, 1);
    expect(supabase, 1);
  });

  test('bootstrap is idempotent until force', () async {
    var inits = 0;
    Future<void> bump() async => inits++;

    final first = await bootstrap(
      AppConfig(
        failureText: testFailureText,
        loadEnv: false,
        wireErrorHandlers: false,
        sessionStore: MemorySecureSessionStore(),
        prefs: MemorySharedPrefsStore(),
        initFirebase: bump,
      ),
    );
    final second = await bootstrap(
      AppConfig(
        failureText: testFailureText,
        loadEnv: false,
        wireErrorHandlers: false,
        sessionStore: MemorySecureSessionStore(),
        prefs: MemorySharedPrefsStore(),
        initFirebase: bump,
      ),
    );

    expect(identical(first, second), isTrue);
    expect(inits, 1);

    final third = await bootstrap(
      AppConfig(
        failureText: testFailureText,
        loadEnv: false,
        wireErrorHandlers: false,
        sessionStore: MemorySecureSessionStore(),
        prefs: MemorySharedPrefsStore(),
        initFirebase: bump,
        force: true,
      ),
    );
    expect(inits, 2);
    expect(identical(first, third), isFalse);
  });

  test('deleteUserData via bootstrap clears listed keys and DB hook', () async {
    final secure = MemorySecureSessionStore({
      'access_token': 'abc',
      'refresh_token': 'xyz',
    });
    final prefs = MemorySharedPrefsStore({
      'email_user': 'a@b.c',
      'theme': 'dark',
    });
    var dbWiped = false;

    final result = await bootstrap(
      AppConfig(
        failureText: testFailureText,
        loadEnv: false,
        wireErrorHandlers: false,
        sessionStore: secure,
        prefs: prefs,
        prefsKeysToClear: const ['email_user'],
        deleteLocalDatabase: () async {
          dbWiped = true;
        },
      ),
    );

    await result.deleteUserData();

    expect(await secure.read('access_token'), isNull);
    expect(await secure.read('refresh_token'), isNull);
    expect(prefs.getString('email_user'), isNull);
    expect(prefs.getString('theme'), 'dark');
    expect(dbWiped, isTrue);
  });
}
