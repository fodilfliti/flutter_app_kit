# Changelog

## [1.1.0] - 2026-09-30

### Added

- `showAppDialog`, `showAppFullScreenDialog`, `showAppBottomSheet`,
  `showConfirmDialog` — responsive Material dialogs/sheets (no strings
  shipped; close tooltip from `MaterialLocalizations`).
- `requireSignIn` + `SignInPromptTexts` — "log in to continue" gate for
  actions (routes stay with nav_kit `AuthGuard`).
- `AppDialogs(navigatorKey:)` — context-free wrapper for controllers.

## [1.0.0] - 2026-09-13

### Added

- First stable pub.dev release.

## [0.0.1] - 2026-09-12

### Added

- Initial local package surface (pre-publish).
