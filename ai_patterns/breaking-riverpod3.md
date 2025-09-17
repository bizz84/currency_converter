# Breaking changes from Riverpod 2.x to Riverpod 3.0

## valueOrNull is now value

- `.valueOrNull` is now `.value`

## Reading notifiers

Given this notifier:

```dart
part 'user_prefs_notifier.g.dart';

@riverpod
class UserPrefsNotifier extends _$UserPrefsNotifier {
  ...

  void method()
}
```

In Riverpod 2.x, it can be accessed like this:

```dart
ref.read(userPrefsNotifierProvider)
ref.watch(userPrefsNotifierProvider)
ref.read(userPrefsNotifierProvider.notifier).method()
```

But in Riverpod 3.0, `Notifier` should be omitted from the provider name:

```dart
ref.read(userPrefsProvider)
ref.watch(userPrefsProvider)
ref.read(userPrefsProvider.notifier).method()
```
