import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'theme_repository.dart';

final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepository();
});

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.dark;
  }

  // Called once at startup (see main.dart) to restore the persisted value
  // before the first frame, since build() can't be async.
  Future<void> load() async {
    state = await ref.read(themeRepositoryProvider).getThemeMode();
  }

  void toggleThemeMode() {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    ref.read(themeRepositoryProvider).saveThemeMode(newMode);
  }
}

final themeNotifier = NotifierProvider<ThemeNotifier, ThemeMode>(() => ThemeNotifier());
