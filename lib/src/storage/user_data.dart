import 'package:flutter_app_kit/src/storage/secure_session_store.dart';
import 'package:flutter_app_kit/src/storage/shared_prefs_store.dart';

/// Sign-out wipe: secure storage, allowlisted prefs keys, optional local DB.
///
/// Does **not** navigate. The router reacts to the session change.
Future<void> deleteUserData({
  required SecureSessionStore sessionStore,
  SharedPrefsStore? prefs,
  Iterable<String> prefsKeys = const [],
  Future<void> Function()? deleteLocalDatabase,
}) async {
  await sessionStore.clear();
  if (prefs != null && prefsKeys.isNotEmpty) {
    await prefs.removeKeys(prefsKeys);
  }
  final wipeDb = deleteLocalDatabase;
  if (wipeDb != null) {
    await wipeDb();
  }
}
