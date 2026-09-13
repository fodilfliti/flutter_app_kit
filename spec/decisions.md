# Decisions

## D1 — flutter_dotenv wrapper, not envied

**Choice:** Load env through a thin `AppEnv` wrapper over `flutter_dotenv`. Apps that want compile-time typed env may still use `envied` on top.

**Why:** Bootstrap must be testable without `build_runner`. `envied` is generated app code; putting it in the kit would force codegen on every consumer and every kit test. Runtime maps plus `envValues` injection keep tests off the network and off assets.

**Do not:** Add `envied` as a kit dependency, or read `.env` from source as Dart constants.

## D2 — Vendor SDKs are callbacks, not package deps

**Choice:** `AppConfig.initFirebase` / `initSupabase` are `Future<void> Function()?`. The kit never imports Firebase or Supabase.

**Why:** A bootstrap package that hard-requires both vendors (or Dio) cannot be used by a REST-only or Firebase-only app. The family forbids those as v1 runtime deps unless justified.

**Do not:** Add `firebase_core` / `supabase_flutter` / `dio` to `pubspec.yaml`.

## D3 — Notices interface stays in page_kit (family D16)

**Choice:** This package ships `MaterialNotices` only. It holds a `GlobalKey<ScaffoldMessengerState>`, never a snapped `currentState`.

**Why:** Controllers depend on `Notices` on day one of page_kit. Storing the key (not the State) means the first snackbar after `runApp` still finds the messenger.

**Do not:** Redefine `Notices`, call slang, or cache `ScaffoldMessenger.of(context)` at bootstrap.

## D4 — Riverpod overrides are app-owned

**Choice:** `BootstrapResult` returns stores, notices, and the messenger key. It does not import Riverpod or return `Override` objects.

**Why:** Family kit design lists `lemsa_core_kit` (+ page_kit for Notices) as runtime deps. Riverpod is the app's DI. The app writes `ProviderScope(overrides: [...])` from the handles.

**Do not:** Add `flutter_riverpod` as a hard dependency of this package.

## D5 — Flavor via `--dart-define`, not native flavor projects

**Choice:** `AppFlavor.fromEnvironment()` reads `--dart-define=FLAVOR=dev|staging|prod`.

**Why:** Native flavor templates and CI matrices are out of scope for v1. A parseable define is enough for API URLs and logging.

## D6 — deleteUserData clears all secure keys, allowlisted prefs only

**Choice:** Secure storage is `clear()` (all tokens). Prefs removal is an explicit key allowlist. Local DB is an injectable `deleteLocalDatabase` hook (Drift later).

**Why:** Sign-out must drop credentials on a shared device. Prefs still hold theme/locale scalars that should survive. The reference-app anti-pattern is `password_user` / `email_user` in SharedPreferences — passwords never belong there; leftover identity keys go on the allowlist.

**Do not:** Navigate from `deleteUserData`. The router reacts to session (nav_kit).

## D7 — flutter_secure_storage 11.x on Flutter ≥ 3.44

**Choice:** Depend on `flutter_secure_storage` `^11.0.0`.

**Why:** Floor table target. Flutter ≥ 3.44 (Dart ≥ 3.12) clears the older win32 / Dart 3.10 blocker that kept us on 10.x under the 3.35.7 pin. Default `FlutterSecureStorage()` is enough; we do not use deprecated `encryptedSharedPreferences`.
