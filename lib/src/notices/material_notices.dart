import 'package:flutter/material.dart';
import 'package:flutter_page_kit/flutter_page_kit.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

/// Material [Notices] — snackbars via root [ScaffoldMessengerState].
///
/// Holds the [GlobalKey] (not a snapshot of `currentState`) so the first
/// notice after cold start still finds the messenger.
///
/// Kits never localize. Inject `failureText` from the app (slang switch).
final class MaterialNotices implements Notices {
  // Public names (messengerKey/failureText) — avoid `this._x` initializing
  // formals so older IDE analyzers and call sites stay aligned.
  MaterialNotices({
    required GlobalKey<ScaffoldMessengerState> messengerKey,
    required String Function(AppFailure) failureText,
  }) {
    _messengerKey = messengerKey;
    _failureText = failureText;
  }

  late final GlobalKey<ScaffoldMessengerState> _messengerKey;
  late final String Function(AppFailure) _failureText;

  void _show(String message, {Color? background}) {
    if (message.isEmpty) {
      return;
    }
    final messenger = _messengerKey.currentState;
    if (messenger == null) {
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  void info(String message) => _show(message);

  @override
  void warn(String message) =>
      _show(message, background: Colors.orange.shade800);

  @override
  void error(String message) => _show(message, background: Colors.red.shade800);

  @override
  void success(String message) =>
      _show(message, background: Colors.green.shade800);

  @override
  void showFailure(AppFailure? failure) {
    if (failure == null || failure is CancelledFailure) {
      return;
    }
    error(_failureText(failure));
  }
}
