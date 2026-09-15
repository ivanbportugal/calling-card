import 'package:calling_card/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/push_token_manager.dart';
import 'routing/router.dart';
import 'theme/app_theme.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  try {
    await PushTokenManager().initialize();
  } catch (error) {
    debugPrint('Failed to initialize push token manager: $error');
  }

  final container = ProviderContainer();
  await container.read(themeNotifier.notifier).load();

  runApp(UncontrolledProviderScope(container: container, child: const CallingCardApp()));
}

class CallingCardApp extends ConsumerWidget {
  const CallingCardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeNotifier);

    return MaterialApp.router(
      title: 'Calling Card',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
