# Absolute imports pattern

To facilitate reuse of common code that is copy-pasted across projects, we can use absolute imports.

For example, use this:

```dart
import '/src/constants/layout_breakpoints.dart';
```

rather than this:

```dart
import 'package:flutter_tips_and_tricks_app/src/constants/layout_breakpoints.dart';
```

