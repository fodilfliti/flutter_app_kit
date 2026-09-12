# flutter_app_kit

App bootstrap, flavors, secure session storage, and Material snackbars for Lemsa apps. Depends on [`lemsa_core_kit`](../lemsa_core_kit) and [`flutter_page_kit`](../flutter_page_kit) (`Notices` interface).

## Install

Path dependency while unpublished:

```yaml
dependencies:
  flutter_app_kit:
    path: ../flutter_app_kit
  flutter_page_kit:
    path: ../flutter_page_kit
  lemsa_core_kit:
    path: ../lemsa_core_kit
```

```dart
import 'package:flutter_app_kit/flutter_app_kit.dart';
```

## Owns

- `bootstrap(AppConfig)` — dotenv, optional vendor init callbacks, prefs / secure storage, error zone
- `AppFlavor` — `dev` / `staging` / `prod` via `--dart-define=FLAVOR=`
- `SecureSessionStore` — tokens and credentials only
- `deleteUserData()` — secure wipe + prefs allowlist + optional local DB hook
- `MaterialNotices` — Material `ScaffoldMessenger` implementation of `Notices`

## Notices rule

Invalid forms → **inline** field errors (`flutter_page_kit`). Do not toast “check the form”.
Use `Notices` for submit/API/important write outcomes.

## Does not own

`PageNavigator` / AuthGuard (`flutter_nav_kit`), `PageData` / `FormPage` (`flutter_page_kit`), Dio/Supabase mappers (`flutter_data_kit_*`), semantic fields (`flutter_input_kit`). Firebase/Supabase SDKs are **not** package dependencies — pass `initFirebase` / `initSupabase` callbacks from the app.
