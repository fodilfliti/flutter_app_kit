import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_kit/src/dialogs/dialog_helpers.dart';
import 'package:flutter_app_kit/src/dialogs/login_prompt.dart';
import 'package:flutter_app_kit/src/dialogs/login_prompt.dart'
    as login_prompt
    show requireSignIn;

/// Context-free dialogs for controllers / services, bound to the root
/// navigator key (auto_route: `router.navigatorKey`).
///
/// Holds the [GlobalKey] (not a context snapshot) so it works after cold
/// start. Every method returns `null` / `false` when no navigator is mounted.
final class AppDialogs {
  AppDialogs({required GlobalKey<NavigatorState> navigatorKey})
    // ignore: prefer_initializing_formals -- keeps the public name `navigatorKey`
    : _navigatorKey = navigatorKey;

  final GlobalKey<NavigatorState> _navigatorKey;

  BuildContext? get _context => _navigatorKey.currentContext;

  Future<T?> dialog<T>(
    WidgetBuilder builder, {
    double maxWidth = 560,
    bool barrierDismissible = true,
    bool showClose = false,
  }) async {
    final context = _context;
    if (context == null) {
      return null;
    }
    return showAppDialog<T>(
      context: context,
      builder: builder,
      maxWidth: maxWidth,
      barrierDismissible: barrierDismissible,
      showClose: showClose,
    );
  }

  Future<T?> fullScreen<T>(WidgetBuilder builder) async {
    final context = _context;
    if (context == null) {
      return null;
    }
    return showAppFullScreenDialog<T>(context: context, builder: builder);
  }

  Future<T?> sheet<T>(
    WidgetBuilder builder, {
    double maxWidth = 640,
    bool showDragHandle = true,
  }) async {
    final context = _context;
    if (context == null) {
      return null;
    }
    return showAppBottomSheet<T>(
      context: context,
      builder: builder,
      maxWidth: maxWidth,
      showDragHandle: showDragHandle,
    );
  }

  Future<bool> confirm({
    required String title,
    required String confirmLabel,
    required String cancelLabel,
    String? message,
    bool destructive = false,
  }) async {
    final context = _context;
    if (context == null) {
      return false;
    }
    return showConfirmDialog(
      context: context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      destructive: destructive,
    );
  }

  Future<bool> requireSignIn({
    required bool Function() isSignedIn,
    required FutureOr<void> Function() openSignIn,
    required SignInPromptTexts texts,
  }) async {
    if (isSignedIn()) {
      return true;
    }
    final context = _context;
    if (context == null) {
      return false;
    }
    return login_prompt.requireSignIn(
      context,
      isSignedIn: isSignedIn,
      openSignIn: openSignIn,
      texts: texts,
    );
  }
}
