import 'package:flutter/material.dart';
import 'package:flutter_app_kit/src/flavor/app_flavor.dart';
import 'package:flutter_app_kit/src/storage/secure_session_store.dart';
import 'package:flutter_app_kit/src/storage/shared_prefs_store.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

/// Phased bootstrap input. Vendor SDKs are callbacks, not package deps.
final class AppConfig {
  const AppConfig({
    required this.failureText,
    this.flavor,
    this.envFileName = '.env',
    this.envValues,
    this.loadEnv = true,
    this.envOptional = true,
    this.initFirebase,
    this.initSupabase,
    this.reporter = const NoOpReporter(),
    this.prefsKeysToClear = const [],
    this.deleteLocalDatabase,
    this.sessionStore,
    this.prefs,
    this.messengerKey,
    this.ensureBinding = true,
    this.wireErrorHandlers = true,
    this.force = false,
  });

  /// App-owned `AppFailure` → user string. Kits never call slang.
  final String Function(AppFailure) failureText;

  /// When null, [AppFlavor.fromEnvironment] (`--dart-define=FLAVOR=`).
  final AppFlavor? flavor;

  /// Asset path passed to flutter_dotenv. App must list it under `assets:`.
  final String envFileName;

  /// When set, skip file load and use this map (tests).
  final Map<String, String>? envValues;

  /// When false, skip dotenv (empty env unless [envValues] is set).
  final bool loadEnv;

  /// Missing `.env` asset is OK when true.
  final bool envOptional;

  /// App passes `() => Firebase.initializeApp()` — this kit does not import it.
  final Future<void> Function()? initFirebase;

  /// App passes Supabase init — this kit does not import it.
  final Future<void> Function()? initSupabase;

  final AppReporter reporter;

  /// Prefs keys removed by `deleteUserData` (allowlist).
  final List<String> prefsKeysToClear;

  /// Drift / local DB wipe. Optional until data_kit.
  final Future<void> Function()? deleteLocalDatabase;

  /// Inject in tests. Production bootstrap creates [FlutterSecureSessionStore].
  final SecureSessionStore? sessionStore;

  /// Inject in tests. Production bootstrap wraps `SharedPreferences`.
  final SharedPrefsStore? prefs;

  /// When null, bootstrap creates a root messenger key.
  final GlobalKey<ScaffoldMessengerState>? messengerKey;

  /// Call `WidgetsFlutterBinding.ensureInitialized`. Tests may set false.
  final bool ensureBinding;

  /// Wire `FlutterError.onError` and `PlatformDispatcher.onError`.
  final bool wireErrorHandlers;

  /// Re-run phases even if bootstrap already completed.
  final bool force;
}
