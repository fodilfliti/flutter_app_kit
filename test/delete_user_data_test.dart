import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'deleteUserData clears listed secure/prefs keys and calls DB hook',
    () async {
      final secure = MemorySecureSessionStore({
        'access_token': 'tok',
        'refresh_token': 'ref',
      });
      final prefs = MemorySharedPrefsStore({
        'email_user': 'old@example.invalid',
        'locale': 'en',
      });
      var dbCalls = 0;

      await deleteUserData(
        sessionStore: secure,
        prefs: prefs,
        prefsKeys: const ['email_user'],
        deleteLocalDatabase: () async {
          dbCalls++;
        },
      );

      expect(await secure.read('access_token'), isNull);
      expect(await secure.read('refresh_token'), isNull);
      expect(prefs.getString('email_user'), isNull);
      expect(prefs.getString('locale'), 'en');
      expect(dbCalls, 1);
    },
  );

  test('deleteUserData without hooks still clears secure storage', () async {
    final secure = MemorySecureSessionStore({'k': 'v'});
    await deleteUserData(sessionStore: secure);
    expect(await secure.read('k'), isNull);
  });
}
