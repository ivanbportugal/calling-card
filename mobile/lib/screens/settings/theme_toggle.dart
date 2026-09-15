import 'package:calling_card/theme/theme.dart';
import 'package:calling_card/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(context.isDarkMode ? Icons.dark_mode : Icons.light_mode),
      tooltip: 'Toggle theme',
      onPressed: () {
        ref.read(themeNotifier.notifier).toggleThemeMode();
      },
    );
  }
}
