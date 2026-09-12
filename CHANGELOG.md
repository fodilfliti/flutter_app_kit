# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-09-12

### Added

- `bootstrap(AppConfig)` — phased, idempotent init with injectable fakes.
- `AppFlavor` (`dev` / `staging` / `prod`) via `--dart-define=FLAVOR=`.
- `AppEnv` flutter_dotenv wrapper (envied left to the app if it wants codegen).
- `SecureSessionStore` + `MemorySecureSessionStore` / `FlutterSecureSessionStore`.
- `SharedPrefsStore` + `deleteUserData()` (secure clear, prefs allowlist, DB hook).
- `MaterialNotices` implementing `flutter_page_kit` `Notices` (D16).
- Flutter / platform error handlers → `AppReporter` (skips `CancelledFailure`).
