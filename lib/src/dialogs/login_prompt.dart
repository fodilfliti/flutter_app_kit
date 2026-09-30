import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_kit/src/dialogs/dialog_helpers.dart';

/// App-supplied strings for [requireSignIn] (kits never localize).
@immutable
class SignInPromptTexts {
  const SignInPromptTexts({
    required this.title,
    required this.signInLabel,
    required this.cancelLabel,
    this.message,
  });

  final String title;
  final String? message;
  final String signInLabel;
  final String cancelLabel;
}

/// "Log in to continue" gate for **actions** (favorite, book, comment).
/// Route-level protection stays with nav_kit's `AuthGuard`.
///
/// Returns `true` when the user is (or becomes) signed in:
/// 1. already signed in → `true` immediately, no dialog;
/// 2. otherwise shows a prompt; cancel → `false`;
/// 3. sign in → awaits [openSignIn] (e.g. `router.push(const LoginRoute())`)
///    then re-checks [isSignedIn].
///
/// ```dart
/// if (!await requireSignIn(context, isSignedIn: () => session.isSignedIn,
///     openSignIn: () => context.router.push(const LoginRoute()),
///     texts: t.auth.prompt)) return;
/// await controller.book();
/// ```
Future<bool> requireSignIn(
  BuildContext context, {
  required bool Function() isSignedIn,
  required FutureOr<void> Function() openSignIn,
  required SignInPromptTexts texts,
}) async {
  if (isSignedIn()) {
    return true;
  }
  final wantsSignIn = await showConfirmDialog(
    context: context,
    title: texts.title,
    message: texts.message,
    confirmLabel: texts.signInLabel,
    cancelLabel: texts.cancelLabel,
  );
  if (!wantsSignIn) {
    return false;
  }
  await openSignIn();
  return isSignedIn();
}
