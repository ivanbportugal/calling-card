import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/user_repository.dart';
import '../friends/friends_repository.dart';
import 'settings/settings_content.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final friends = ref.watch(friendsProvider);
    final requests = ref.watch(friendRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(userProfileProvider.future),
            ref.refresh(friendsProvider.future),
            ref.refresh(friendRequestsProvider.future),
          ]);
        },
        child: SettingsContent(
          profile: profile,
          friends: friends,
          requests: requests,
        ),
      ),
    );
  }
}
