import 'package:flutter/material.dart';

/// Responsive Material dialog: full width on phones, capped at [maxWidth] on
/// tablets / desktop / web, never taller than [maxHeightFactor] of the screen.
///
/// [showClose] adds a top-end close button (localized tooltip from
/// [MaterialLocalizations] — kits never ship strings).
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double maxWidth = 560,
  double maxHeightFactor = 0.9,
  bool barrierDismissible = true,
  bool showClose = false,
  EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  Color? backgroundColor,
  Color? barrierColor,
  ShapeBorder? shape,
  bool useRootNavigator = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useRootNavigator: useRootNavigator,
    builder: (dialogContext) {
      final size = MediaQuery.sizeOf(dialogContext);
      Widget body = Padding(padding: padding, child: builder(dialogContext));
      if (showClose) {
        body = Stack(
          children: [
            body,
            PositionedDirectional(
              top: 4,
              end: 4,
              child: CloseButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          ],
        );
      }
      return Dialog(
        backgroundColor: backgroundColor,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: size.height * maxHeightFactor,
          ),
          child: body,
        ),
      );
    },
  );
}

/// Full-screen dialog (M3 `Dialog.fullscreen`). The child owns its chrome,
/// e.g. a `Scaffold` with an `AppBar` + `CloseButton`.
Future<T?> showAppFullScreenDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  bool useRootNavigator = true,
}) {
  return showDialog<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (dialogContext) => Dialog.fullscreen(
      backgroundColor: backgroundColor,
      child: builder(dialogContext),
    ),
  );
}

/// Modal bottom sheet with sane defaults: scroll-controlled, safe area,
/// drag handle, width capped on large screens, height capped at
/// [maxHeightFactor].
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double maxWidth = 640,
  double maxHeightFactor = 0.9,
  bool showDragHandle = true,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
  bool useRootNavigator = true,
}) {
  final size = MediaQuery.sizeOf(context);
  return showModalBottomSheet<T>(
    context: context,
    builder: builder,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: showDragHandle,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: backgroundColor,
    useRootNavigator: useRootNavigator,
    clipBehavior: Clip.antiAlias,
    constraints: BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: size.height * maxHeightFactor,
    ),
  );
}

/// Yes/no dialog. Returns `true` only when confirmed (dismiss → `false`).
///
/// All strings are app-supplied (kits never localize). [destructive] paints
/// the confirm action with `colorScheme.error`.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  required String cancelLabel,
  String? message,
  bool destructive = false,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (dialogContext) {
      final scheme = Theme.of(dialogContext).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  )
                : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
