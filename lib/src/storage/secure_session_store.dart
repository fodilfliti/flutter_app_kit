import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Tokens and credentials. Never use SharedPreferences for these.
abstract interface class SecureSessionStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  /// Drops every stored secret. Used by `deleteUserData`.
  Future<void> clear();
}

/// In-memory store for tests and harnesses.
final class MemorySecureSessionStore implements SecureSessionStore {
  MemorySecureSessionStore([Map<String, String>? initial])
    : _values = Map<String, String>.from(initial ?? {});

  final Map<String, String> _values;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> clear() async {
    _values.clear();
  }
}

/// Production store backed by [FlutterSecureStorage].
final class FlutterSecureSessionStore implements SecureSessionStore {
  FlutterSecureSessionStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}
