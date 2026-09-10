import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/user_repository.dart';
import 'home/error_state.dart';
import 'home/home_content.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(profileProvider.future),
        child: profile.when(
          data: (user) => HomeContent(user: user),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorState(onRetry: () => ref.invalidate(profileProvider)),
        ),
      ),
    );
  }
}
