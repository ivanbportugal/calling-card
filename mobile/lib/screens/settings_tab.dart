import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth_providers.dart';
import '../auth/user.dart';
import '../auth/user_repository.dart';
import '../friends/friends_repository.dart';
import '../models/friend.dart';
import '../models/friend_request.dart';
import '../theme/status_color_extensions.dart';
import '../theme/theme_extensions.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final friends = ref.watch(friendsProvider);
    final requests = ref.watch(friendRequestsProvider);
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  profile.when(
                    data: (user) => Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          backgroundImage: user.photoUrl.isNotEmpty
                              ? NetworkImage(user.photoUrl)
                              : null,
                          child: user.photoUrl.isEmpty
                              ? Text(
                                  user.displayName.isNotEmpty ? user.displayName[0] : '?',
                                  style: context.textTheme.headlineSmall,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.displayName, style: context.textTheme.titleLarge),
                              Text(
                                user.email,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, _) => Text(
                      "Couldn't load your name.",
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Friends', style: context.textTheme.titleMedium),
                      TextButton.icon(
                        onPressed: () => _showAddFriendDialog(context, ref),
                        icon: const Icon(Icons.person_add_outlined),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  friends.when(
                    data: (friendList) => friendList.isEmpty
                        ? Text(
                            'No friends yet.',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          )
                        : Column(
                            children: friendList
                                .map(
                                  (friend) => Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: colorScheme.surfaceContainerHighest,
                                        child: Text(
                                          (friend.displayName?.isNotEmpty ?? false)
                                              ? friend.displayName![0]
                                              : '?',
                                        ),
                                      ),
                                      title: Text(friend.displayName ?? friend.email ?? 'Unknown'),
                                      subtitle: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: (friend.status ?? StatusColor.RED).resolve(colorScheme),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text((friend.status ?? StatusColor.RED).shortLabel),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.person_remove_outlined),
                                        tooltip: 'Remove friend',
                                        onPressed: () => _removeFriend(context, ref, friend),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, _) => Text(
                      "Couldn't load your friends.",
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  requests.when(
                    data: (friendRequests) {
                      if (friendRequests.incoming.isEmpty && friendRequests.outgoing.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text('Friend requests', style: context.textTheme.titleMedium),
                          const SizedBox(height: 12),
                          ...friendRequests.incoming.map(
                            (request) => Card(
                              child: ListTile(
                                title: Text(request.user.displayName ?? request.user.email ?? 'Unknown'),
                                subtitle: const Text('wants to be friends'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check),
                                      tooltip: 'Accept',
                                      onPressed: () => _acceptRequest(context, ref, request),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      tooltip: 'Decline',
                                      onPressed: () => _declineRequest(context, ref, request),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ...friendRequests.outgoing.map(
                            (request) => Card(
                              child: ListTile(
                                title: Text(request.user.displayName ?? request.user.email ?? 'Unknown'),
                                subtitle: const Text('request sent'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  tooltip: 'Cancel request',
                                  onPressed: () => _declineRequest(context, ref, request),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
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
      ),
    );
  }

  Future<void> _showAddFriendDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final userId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add a friend'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Friend's user ID"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Send request'),
          ),
        ],
      ),
    );

    if (userId == null || userId.isEmpty) return;

    try {
      await ref.read(friendsRepositoryProvider).sendFriendRequest(userId);
      ref.invalidate(friendRequestsProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't send that friend request.")),
        );
      }
    }
  }

  Future<void> _removeFriend(BuildContext context, WidgetRef ref, Friend friend) async {
    try {
      await ref.read(friendsRepositoryProvider).removeFriend(friend.id);
      ref.invalidate(friendsProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't remove that friend.")),
        );
      }
    }
  }

  Future<void> _acceptRequest(BuildContext context, WidgetRef ref, FriendRequest request) async {
    try {
      await ref.read(friendsRepositoryProvider).acceptFriendRequest(request.id);
      ref.invalidate(friendRequestsProvider);
      ref.invalidate(friendsProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't accept that request.")),
        );
      }
    }
  }

  Future<void> _declineRequest(BuildContext context, WidgetRef ref, FriendRequest request) async {
    try {
      await ref.read(friendsRepositoryProvider).declineFriendRequest(request.id);
      ref.invalidate(friendRequestsProvider);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't remove that request.")),
        );
      }
    }
  }
}
