import 'package:flutter_app_kit/flutter_app_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemsa_core_kit/lemsa_core_kit.dart';

import 'helpers/recording_reporter.dart';

void main() {
  test('CancelledFailure is not reported', () {
    final reporter = RecordingReporter();
    reportError(reporter, const CancelledFailure(), StackTrace.empty);
    expect(reporter.failures, isEmpty);
    expect(reporter.crashes, isEmpty);
    expect(reporter.breadcrumbs, isEmpty);
  });

  test('ValidationFailure is breadcrumb only', () {
    final reporter = RecordingReporter();
    reportError(
      reporter,
      const ValidationFailure({'title': 'required'}),
      StackTrace.empty,
    );
    expect(reporter.breadcrumbs, ['validation']);
    expect(reporter.failures, isEmpty);
    expect(reporter.crashes, isEmpty);
  });

  test('UnknownFailure is crash', () {
    final reporter = RecordingReporter();
    reportError(reporter, const UnknownFailure(), StackTrace.empty);
    expect(reporter.crashes, hasLength(1));
    expect(reporter.failures, isEmpty);
  });

  test('NetworkFailure is failure', () {
    final reporter = RecordingReporter();
    reportError(reporter, const NetworkFailure(), StackTrace.empty);
    expect(reporter.failures, hasLength(1));
    expect(reporter.failures.first, isA<NetworkFailure>());
    expect(reporter.crashes, isEmpty);
  });

  test('unexpected Object is crash', () {
    final reporter = RecordingReporter();
    reportError(reporter, StateError('boom'), StackTrace.empty);
    expect(reporter.crashes.single, isA<StateError>());
  });
}
