# Agent instructions — Flutter App Kit

This is a **Flutter package** (`flutter_app_kit`), not an application.

## Load context

1. Read `spec/README.md`, then `package.md` / `invariants.md` / `decisions.md`.
2. Use **code** under `lib/` as implementation truth.
3. Do **not** ingest `README.md` as working memory.

## Working rules

- Keep the public barrel (`lib/flutter_app_kit.dart`) the only public API.
- `Notices` is defined in `flutter_page_kit`. This package implements `MaterialNotices` only (D16).
- No hard runtime deps on `dio`, `supabase_flutter`, or `firebase_*`. Apps pass `initFirebase` / `initSupabase` callbacks.
- Secrets never committed. `.env` is gitignored; `.env.example` is shipped.
- Credentials live in `SecureSessionStore`, never SharedPreferences (`password_user` anti-pattern).
- `deleteUserData()` clears secure storage + allowlisted prefs keys + optional DB hook. It does **not** navigate.
- `CancelledFailure` is never shown and never reported.
- Kits never localize — inject `failureText`.
- Empty catches are analyzer errors.
- After behavior changes: update `spec/` (and `CHANGELOG.md` when user-visible). Update `skills/flutter-app-kit/` for public API changes.

## Flutter SDK

Pinned in `.fvmrc` to **3.35.7**. Use `fvm flutter` / `fvm dart`. Never run `flutter upgrade` / `flutter channel` on `C:\Users\lemsa\Documents\flutter`. Package constraints: Dart `^3.7.2`, Flutter `>=3.29.0`.

## Out of scope unless asked

Publishing to pub.dev, `flutter_nav_kit`, `flutter_input_kit`, `flutter_data_kit`, migrating lab / reference apps.
