# Invariants

- Public export **only** via `lib/flutter_app_kit.dart`.
- `Notices` is not redefined here. `MaterialNotices implements Notices` from `flutter_page_kit` (D16).
- Kits never localize. `showFailure` maps through an injected `failureText`.
- `showFailure` skips `null` and `CancelledFailure`. Empty mapped text is not shown.
- `CancelledFailure` is never reported to `AppReporter`.
- `ValidationFailure` is breadcrumb-only. `UnknownFailure` is always `crash`.
- Tokens and credentials live in `SecureSessionStore` only. Never write passwords (or `password_user`) to SharedPreferences.
- `deleteUserData()` clears secure storage, allowlisted prefs keys, and the optional DB hook. It performs **no navigation**.
- Bootstrap is idempotent. Phases are overridable with fakes (no network in tests).
- Firebase / Supabase / Dio are never hard dependencies. Optional `initFirebase` / `initSupabase` callbacks only.
- Secrets never committed (`.env` gitignored; `.env.example` shipped).
- Empty `catch` is banned (`empty_catches: error`).
- No `PageNavigator`, AuthGuard, PageData, or data_kit mappers in this package.
