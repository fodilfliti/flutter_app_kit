import 'package:flutter/material.dart';
import 'package:flutter_app_kit/src/bootstrap/app_env.dart';
import 'package:flutter_app_kit/src/flavor/app_flavor.dart';
import 'package:flutter_app_kit/src/notices/material_notices.dart';
import 'package:flutter_app_kit/src/storage/secure_session_store.dart';
import 'package:flutter_app_kit/src/storage/shared_prefs_store.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

/// Handles for `runApp`. Map into Riverpod overrides at the app layer —
/// this package does not depend on Riverpod.
final class BootstrapResult {
  const BootstrapResult({
    required this.flavor,
    required this.env,
    required this.reporter,
    required this.messengerKey,
    required this.notices,
    required this.sessionStore,
    required this.prefs,
    required this.deleteUserData,
  });

  final AppFlavor flavor;
  final AppEnv env;
  final AppReporter reporter;
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  final MaterialNotices notices;
  final SecureSessionStore sessionStore;
  final SharedPrefsStore prefs;

  /// Clears secure storage, allowlisted prefs, optional DB. Does not navigate.
  final Future<void> Function() deleteUserData;
}
