# Adaptive alert dialog pattern

Goal: Show a cupertino alert dialog on iOS/macOS and an alert dialog on all other platforms.

## Show alert dialog

Create this file if missing:

```dart
// lib/src/common_widgets/show_alert_dialog.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  required String defaultActionText,
  bool isDestructive = false,
}) async {
  if (kIsWeb ||
      defaultTargetPlatform != TargetPlatform.iOS &&
          defaultTargetPlatform != TargetPlatform.macOS) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          isDestructiveAction: isDestructive,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
```

## Example usage

```dart
final shouldClear = await showAlertDialog(
  context: context,
  title: 'Are you sure?',
  content:
      'This will delete all the cached images and data. All your favorites will be preserved.',
  cancelActionText: 'Cancel',
  defaultActionText: 'Delete',
  isDestructive: true,
);
if (shouldClear == true) {
  await clearCacheNotifier.clearCache();
  // ignore_for_file: use_build_context_synchronously
  await showAlertDialog(
    context: context,
    title: 'Cache deleted',
    content: 'All the cached images and data have been deleted.',
    defaultActionText: 'OK',
  );
}
```