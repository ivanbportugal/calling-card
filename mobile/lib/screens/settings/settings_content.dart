import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../auth/user.dart';
import '../../models/friend.dart';
import '../../models/friend_request.dart';
import '../../theme/theme_extensions.dart';
import 'add_friend_dialog.dart';
import 'friend_requests_list.dart';
import 'friends_list.dart';
import 'profile_header.dart';
import 'theme_toggle.dart';

class SettingsContent extends ConsumerWidget {
  const SettingsContent({
    super.key,
    required this.profile,
    required this.friends,
    required this.requests,
  });

  final AsyncValue<User> profile;
  final AsyncValue<List<Friend>> friends;
  final AsyncValue<FriendRequests> requests;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProfileHeader(profile: profile),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Theme', style: context.textTheme.titleMedium),
                    ThemeToggle(),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Friends', style: context.textTheme.titleMedium),
                    TextButton.icon(
                      onPressed: () => showAddFriendDialog(context, ref),
                      icon: const Icon(Icons.person_add_outlined),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FriendsList(friends: friends),
                FriendRequestsList(requests: requests),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(authRepositoryProvider).signOut(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.tertiary,
                  side: BorderSide(color: colorScheme.tertiary),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
