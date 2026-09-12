import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

bool _capturedPrevious = false;
FlutterExceptionHandler? _previousFlutterOnError;
ErrorCallback? _previousPlatformOnError;

/// Routes an error to [reporter] using family reporting rules.
void reportError(AppReporter reporter, Object error, StackTrace stack) {
  if (error is CancelledFailure) {
    return;
  }
  if (error is ValidationFailure) {
    reporter.breadcrumb(
      'validation',
      data: {'fields': error.fields},
    );
    return;
  }
  if (error is UnknownFailure) {
    reporter.crash(error, error.trace ?? stack);
    return;
  }
  if (error is AppFailure) {
    reporter.failure(error, error.trace ?? stack);
    return;
  }
  reporter.crash(error, stack);
}

/// Wires [FlutterError.onError] and [PlatformDispatcher.onError].
void installErrorHandlers(AppReporter reporter) {
  if (!_capturedPrevious) {
    _previousFlutterOnError = FlutterError.onError;
    _previousPlatformOnError = PlatformDispatcher.instance.onError;
    _capturedPrevious = true;
  }

  FlutterError.onError = (details) {
    reportError(
      reporter,
      details.exception,
      details.stack ?? StackTrace.empty,
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    reportError(reporter, error, stack);
    return true;
  };
}

/// Restores handlers captured by [installErrorHandlers].
void restoreErrorHandlers() {
  if (!_capturedPrevious) {
    return;
  }
  FlutterError.onError = _previousFlutterOnError;
  PlatformDispatcher.instance.onError = _previousPlatformOnError;
  _capturedPrevious = false;
  _previousFlutterOnError = null;
  _previousPlatformOnError = null;
}
