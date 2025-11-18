import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Shows a platform-adaptive alert dialog using Flutter's built-in adaptive APIs.
Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  required String defaultActionText,
  bool isDestructive = false,
}) async {
  return showAdaptiveDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: <Widget>[
        if (cancelActionText != null)
          _adaptiveAction(
            context: context,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelActionText),
          ),
        _adaptiveAction(
          context: context,
          isDefaultAction: true,
          isDestructiveAction: isDestructive,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}

/// Creates a platform-adaptive action button for dialogs.
///
/// Returns [TextButton] on Material platforms (Android, Fuchsia, Linux, Windows)
/// and [CupertinoDialogAction] on Apple platforms (iOS, macOS).
///
/// Uses [Theme.of(context).platform] instead of [defaultTargetPlatform] for
/// better testability and theme-level platform overrides.
Widget _adaptiveAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
  bool isDefaultAction = false,
  bool isDestructiveAction = false,
}) {
  final ThemeData theme = Theme.of(context);
  return switch (theme.platform) {
    TargetPlatform.android ||
    TargetPlatform.fuchsia ||
    TargetPlatform.linux ||
    TargetPlatform.windows => TextButton(
      onPressed: onPressed,
      child: child,
    ),
    TargetPlatform.iOS || TargetPlatform.macOS => CupertinoDialogAction(
      isDefaultAction: isDefaultAction,
      isDestructiveAction: isDestructiveAction,
      onPressed: onPressed,
      child: child,
    ),
  };
}
