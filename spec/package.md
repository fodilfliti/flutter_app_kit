# flutter_app_kit

App bootstrap, env/flavors, secure storage, global error handlers, and Material Notices.

## Layers

| Layer | Path | Role |
| --- | --- | --- |
| Barrel | `lib/flutter_app_kit.dart` | Only public export |
| Bootstrap | `lib/src/bootstrap/` | `AppConfig`, `bootstrap`, `AppEnv`, result handles |
| Flavor | `lib/src/flavor/` | `AppFlavor` (`dev` / `staging` / `prod`) |
| Storage | `lib/src/storage/` | Secure session, prefs wrapper, `deleteUserData` |
| Notices | `lib/src/notices/` | `MaterialNotices` (interface is in page_kit) |
| Error zone | `lib/src/error/` | `FlutterError` / `PlatformDispatcher` → `AppReporter` |

## Public API

- `bootstrap(AppConfig)` → `BootstrapResult`
- `AppConfig`, `AppEnv`, `AppFlavor`
- `SecureSessionStore`, `MemorySecureSessionStore`, `FlutterSecureSessionStore`
- `SharedPrefsStore`, `MemorySharedPrefsStore`, `SharedPreferencesStore`
- `deleteUserData(...)`
- `MaterialNotices`
- `installErrorHandlers` / `reportError` / `debugResetBootstrap`

`BootstrapResult` is the small runApp handle: messenger key, notices, stores, env, flavor, `deleteUserData`. The app maps those into Riverpod `ProviderScope.overrides` — this kit does not depend on Riverpod.

## Depends on

- `lemsa_core_kit` — `AppFailure`, `AppReporter`
- `flutter_page_kit` — `Notices` interface (D16)
- `flutter_dotenv`, `flutter_secure_storage`, `shared_preferences`

## Must not depend on

`dio`, `supabase_flutter`, `firebase_*`, `auto_route`, `slang`, `flutter_riverpod` (hard).
