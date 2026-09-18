import 'package:calling_card/auth/user_repository.dart';
import 'package:calling_card/firebase_options.dart';
import 'package:calling_card/friends/friends_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class CallingCardApp extends HookConsumerWidget {
  const CallingCardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeNotifier);

    useOnAppLifecycleStateChange((previous, current) {
      if (current == AppLifecycleState.resumed) {
        ref.refresh(userProfileProvider.future);
        ref.refresh(friendsProvider.future);
        ref.refresh(friendRequestsProvider.future);
      }
    });

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
