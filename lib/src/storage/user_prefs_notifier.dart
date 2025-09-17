import 'package:currency_converter/src/data/currency.dart';
import 'package:currency_converter/src/storage/user_prefs_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_prefs_notifier.g.dart';

class UserPrefsState {
  const UserPrefsState({
    required this.baseCurrency,
    required this.amount,
    required this.targetCurrencies,
  });

  final Currency baseCurrency;
  final double amount;
  final List<Currency> targetCurrencies;

  UserPrefsState copyWith({
    Currency? baseCurrency,
    double? amount,
    List<Currency>? targetCurrencies,
  }) {
    return UserPrefsState(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      amount: amount ?? this.amount,
      targetCurrencies: targetCurrencies ?? this.targetCurrencies,
    );
  }
}

@riverpod
class UserPrefsNotifier extends _$UserPrefsNotifier {
  @override
  UserPrefsState build() {
    final repo = ref.read(userPrefsRepositoryProvider);
    final base = repo.loadBase();
    final amount = repo.loadAmount();
    final targets = repo.loadTargets(base: base);
    return UserPrefsState(
      baseCurrency: base,
      amount: amount,
      targetCurrencies: targets,
    );
  }

  Future<void> setBase(Currency base) async {
    state = state.copyWith(baseCurrency: base);
    await ref.read(userPrefsRepositoryProvider).saveBase(base);
  }

  Future<void> setAmount(double amount) async {
    state = state.copyWith(amount: amount);
    await ref.read(userPrefsRepositoryProvider).saveAmount(amount);
  }

  Future<void> addTarget(Currency currency) async {
    if (state.targetCurrencies.contains(currency)) return;
    final updated = [...state.targetCurrencies, currency];
    state = state.copyWith(targetCurrencies: updated);
    await ref.read(userPrefsRepositoryProvider).saveTargets(updated);
  }

  Future<void> removeTarget(Currency currency) async {
    final updated = state.targetCurrencies.where((c) => c != currency).toList();
    state = state.copyWith(targetCurrencies: updated);
    await ref.read(userPrefsRepositoryProvider).saveTargets(updated);
  }

  Future<void> reorderTargets(int oldIndex, int newIndex) async {
    final list = [...state.targetCurrencies];
    if (oldIndex < newIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = state.copyWith(targetCurrencies: list);
    await ref.read(userPrefsRepositoryProvider).saveTargets(list);
  }
}
