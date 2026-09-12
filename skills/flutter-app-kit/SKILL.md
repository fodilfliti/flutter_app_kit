---
name: flutter-app-kit
description: >
  Use flutter_app_kit for bootstrap(), AppFlavor, SecureSessionStore,
  deleteUserData, MaterialNotices, and wiring FlutterError to AppReporter.
  Activate for main.dart init, .env / flavors, secure tokens, sign-out wipe,
  and ScaffoldMessenger snackbars — not for PageData, auto_route, AuthGuard,
  Dio mappers, or Firebase/Supabase SDKs inside this package.
license: MIT
metadata:
  author: fodilfliti
  version: "0.0.1"
  homepage: https://pub.dev/packages/flutter_app_kit
---

# flutter_app_kit (consumer)

## When to import

```dart
import 'package:flutter_app_kit/flutter_app_kit.dart';
```

Use this package for:

- `bootstrap(AppConfig)` in `main()` before `runApp`
- `AppFlavor` (`--dart-define=FLAVOR=dev|staging|prod`)
- Tokens in `SecureSessionStore` (never SharedPreferences)
- `deleteUserData()` on sign-out (no navigation)
- `MaterialNotices` (production `Notices` impl)

## Bootstrap phases

1. `WidgetsFlutterBinding.ensureInitialized`
2. Load env (`flutter_dotenv` via `AppEnv`, or inject `envValues` in tests)
3. Optional `initFirebase` / `initSupabase` callbacks (app owns the SDKs)
4. Prefs + secure storage
5. `FlutterError.onError` + `PlatformDispatcher.onError` → `AppReporter`
6. Return handles: messenger key, `MaterialNotices`, stores, `deleteUserData`

Map handles into Riverpod overrides **in the app**. This kit does not depend on Riverpod.

```dart
Future<void> main() async {
  final app = await bootstrap(
    AppConfig(
      failureText: failureText, // app-owned slang switch
      initFirebase: () => Firebase.initializeApp(),
      prefsKeysToClear: const ['email_user'],
      deleteLocalDatabase: () => database.deleteUserData(),
    ),
  );
  runApp(
    ProviderScope(
      overrides: [
        noticesProvider.overrideWithValue(app.notices),
        secureSessionStoreProvider.overrideWithValue(app.sessionStore),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: app.messengerKey,
        home: const Home(),
      ),
    ),
  );
}
```

## Notices rule

- **Do** toast save success, network/API failures, delete/sync — important writes.
- **Do not** toast form validation. Invalid fields are inline (`errorText` / `showFieldErrors`) in page_kit / input_kit.
- `showFailure` skips `null` and `CancelledFailure`. Inject `failureText`; kits never call slang.
- Hold the root `GlobalKey<ScaffoldMessengerState>` (already on `BootstrapResult.messengerKey`).

## Sign-out

Call `await handles.deleteUserData()` (or `deleteUserData(...)`). Then update session. **Do not** `Navigator.pushAndRemoveUntil`. The router (nav_kit) reacts to session.

Clears three layers: providers (via session dependency), local DB hook, secure storage. Prefs only for keys you list (`email_user`, etc.). Theme/locale stay.

## Storage

| Data | Home |
| --- | --- |
| Tokens, refresh tokens, credentials | `SecureSessionStore` |
| Scalars: theme, locale, onboarding | `SharedPrefsStore` |
| Entities | Drift later — pass `deleteLocalDatabase` |

Never write `password_user` (or any password) to SharedPreferences. That is the reference-app anti-pattern this kit exists to stop.

## Env

`.env` is gitignored. Commit `.env.example`. Load as a Flutter asset in the **app**. Tests pass `loadEnv: false` or `envValues: {...}`.

## Do not put here

| Concern | Where |
| --- | --- |
| `PageNavigator` / AuthGuard / auto_route | `flutter_nav_kit` |
| `PageData` / `FormPage` / `Notices` interface | `flutter_page_kit` |
| EmailField / Validators UI | `flutter_input_kit` |
| Dio / Supabase mappers | `flutter_data_kit_*` |
| `AppFailure` / `AppReporter` | `lemsa_core_kit` |
| Firebase / Supabase init implementation | the app (callbacks only) |
