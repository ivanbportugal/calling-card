import 'package:calling_card/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const ProviderScope(child: CallingCardApp()));
}

class CallingCardApp extends ConsumerWidget {
  const CallingCardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Calling Card',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
