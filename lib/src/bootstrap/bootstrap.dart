import 'package:flutter/material.dart';
import 'package:flutter_app_kit/src/bootstrap/app_config.dart';
import 'package:flutter_app_kit/src/bootstrap/app_env.dart';
import 'package:flutter_app_kit/src/bootstrap/bootstrap_result.dart';
import 'package:flutter_app_kit/src/error/error_zone.dart';
import 'package:flutter_app_kit/src/flavor/app_flavor.dart';
import 'package:flutter_app_kit/src/notices/material_notices.dart';
import 'package:flutter_app_kit/src/storage/secure_session_store.dart';
import 'package:flutter_app_kit/src/storage/shared_prefs_store.dart';
import 'package:flutter_app_kit/src/storage/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

BootstrapResult? _cached;

/// Phased, idempotent bootstrap. Inject fakes on [AppConfig] for tests.
Future<BootstrapResult> bootstrap(AppConfig config) async {
  if (_cached != null && !config.force) {
    return _cached!;
  }
  final result = await _runPhases(config);
  _cached = result;
  return result;
}

/// Clears cached bootstrap and restores previous error handlers (tests).
@visibleForTesting
void debugResetBootstrap() {
  _cached = null;
  restoreErrorHandlers();
}

Future<BootstrapResult> _runPhases(AppConfig config) async {
  if (config.ensureBinding) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  final flavor = config.flavor ?? AppFlavor.fromEnvironment();
  final env = await _loadEnv(config);

  final initFirebase = config.initFirebase;
  if (initFirebase != null) {
    await initFirebase();
  }
  final initSupabase = config.initSupabase;
  if (initSupabase != null) {
    await initSupabase();
  }

  final prefs =
      config.prefs ??
      SharedPreferencesStore(await SharedPreferences.getInstance());
  final sessionStore = config.sessionStore ?? FlutterSecureSessionStore();

  if (config.wireErrorHandlers) {
    installErrorHandlers(config.reporter);
  }

  final messengerKey =
      config.messengerKey ?? GlobalKey<ScaffoldMessengerState>();
  final notices = MaterialNotices(
    messengerKey: messengerKey,
    failureText: config.failureText,
  );

  return BootstrapResult(
    flavor: flavor,
    env: env,
    reporter: config.reporter,
    messengerKey: messengerKey,
    notices: notices,
    sessionStore: sessionStore,
    prefs: prefs,
    deleteUserData:
        () => deleteUserData(
          sessionStore: sessionStore,
          prefs: prefs,
          prefsKeys: config.prefsKeysToClear,
          deleteLocalDatabase: config.deleteLocalDatabase,
        ),
  );
}

Future<AppEnv> _loadEnv(AppConfig config) {
  final injected = config.envValues;
  if (injected != null) {
    return Future.value(AppEnv.fromMap(injected));
  }
  if (!config.loadEnv) {
    return Future.value(AppEnv.empty);
  }
  return AppEnv.loadDotenv(
    fileName: config.envFileName,
    isOptional: config.envOptional,
  );
}
