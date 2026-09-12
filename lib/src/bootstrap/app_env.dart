import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime env map. Loaded from dotenv or injected for tests.
///
/// Apps that want compile-time typed env may wrap this with envied at the
/// app layer; this kit does not depend on envied.
final class AppEnv {
  const AppEnv(this.values);

  factory AppEnv.fromMap(Map<String, String> values) {
    return AppEnv(Map<String, String>.unmodifiable(values));
  }

  static const empty = AppEnv(<String, String>{});

  final Map<String, String> values;

  String? get(String key) => values[key];

  String require(String key) {
    final value = values[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing env key "$key"');
    }
    return value;
  }

  /// Loads [fileName] as a Flutter asset via flutter_dotenv.
  static Future<AppEnv> loadDotenv({
    String fileName = '.env',
    bool isOptional = true,
    Map<String, String> mergeWith = const {},
  }) async {
    final instance = DotEnv();
    try {
      await instance.load(
        fileName: fileName,
        isOptional: isOptional,
        mergeWith: mergeWith,
      );
    } on Object catch (error, stack) {
      if (!isOptional) {
        Error.throwWithStackTrace(error, stack);
      }
      return AppEnv.fromMap(mergeWith);
    }
    return AppEnv.fromMap({...mergeWith, ...instance.env});
  }
}
