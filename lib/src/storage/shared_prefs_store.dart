import 'package:shared_preferences/shared_preferences.dart';

/// Keys that must never be written to prefs (reference-app anti-pattern).
const bannedPrefsSecretKeys = {'password_user', 'password'};

bool isBannedPrefsSecretKey(String key) => bannedPrefsSecretKeys.contains(key);

const _bannedPrefsMessage =
    'Never store passwords in SharedPreferences '
    '(anti-pattern: password_user). Use SecureSessionStore.';

/// Thin prefs wrapper used by bootstrap and `deleteUserData`.
abstract interface class SharedPrefsStore {
  String? getString(String key);

  Future<void> setString(String key, String value);

  Future<void> remove(String key);

  Future<void> removeKeys(Iterable<String> keys);
}

final class MemorySharedPrefsStore implements SharedPrefsStore {
  MemorySharedPrefsStore([Map<String, String>? initial])
    : _values = Map<String, String>.from(initial ?? {});

  final Map<String, String> _values;

  @override
  String? getString(String key) => _values[key];

  @override
  Future<void> setString(String key, String value) async {
    assert(!isBannedPrefsSecretKey(key), _bannedPrefsMessage);
    _values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> removeKeys(Iterable<String> keys) async {
    for (final key in keys) {
      _values.remove(key);
    }
  }
}

final class SharedPreferencesStore implements SharedPrefsStore {
  SharedPreferencesStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    assert(!isBannedPrefsSecretKey(key), _bannedPrefsMessage);
    await _prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> removeKeys(Iterable<String> keys) async {
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
