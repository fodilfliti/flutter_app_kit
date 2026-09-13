# flutter_app_kit

[![pub package](https://img.shields.io/pub/v/flutter_app_kit.svg)](https://pub.dev/packages/flutter_app_kit)

App bootstrap, flavors, secure session storage, and Material snackbars for Lemsa apps.

**Platforms:** Android, iOS, Linux, macOS, Web, Windows  
**Requires:** Flutter `>=3.44.0`

## Install

```yaml
dependencies:
  flutter_app_kit: ^1.0.0
  flutter_page_kit: ^1.0.0
  lemsa_core_kit: ^1.0.0
```

```dart
import 'package:flutter_app_kit/flutter_app_kit.dart';
```

## Owns

- `bootstrap(AppConfig)` — dotenv, optional vendor init callbacks, prefs / secure storage, error zone
- `AppFlavor` — `dev` / `staging` / `prod` via `--dart-define=FLAVOR=`
- `SecureSessionStore` — tokens/credentials only
- `deleteUserData()` — secure wipe + prefs allowlist + optional local DB hook
- `MaterialNotices` — Material `ScaffoldMessenger` implementation of `Notices`

Firebase/Supabase SDKs are **not** package dependencies — pass `initFirebase` / `initSupabase` callbacks from the app.

## Agent skill

```bash
npx skills add fodilfliti/flutter_app_kit
# or: npx skills add fodilfliti/lemsa-skills
```

## Links

- [GitHub](https://github.com/fodilfliti/flutter_app_kit)
- [Lemsa skills](https://github.com/fodilfliti/lemsa-skills)
