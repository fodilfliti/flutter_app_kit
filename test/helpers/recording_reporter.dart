import 'package:lemsa_core_kit/lemsa_core_kit.dart';

final class RecordingReporter implements AppReporter {
  final failures = <AppFailure>[];
  final crashes = <Object>[];
  final breadcrumbs = <String>[];

  @override
  void failure(AppFailure f, StackTrace? trace) => failures.add(f);

  @override
  void crash(Object error, StackTrace trace) => crashes.add(error);

  @override
  void breadcrumb(String message, {Map<String, Object?> data = const {}}) {
    breadcrumbs.add(message);
  }
}
