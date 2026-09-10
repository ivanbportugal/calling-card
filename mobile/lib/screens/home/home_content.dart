import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/user.dart';
import '../../friends/friends_repository.dart';
import '../../models/friend.dart';
import '../../theme/app_theme.dart';
import '../../theme/status_color_extensions.dart';
import '../../theme/theme_extensions.dart';
import 'status_option.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final status = user.status?.color ?? StatusColor.RED;
    final friends = ref.watch(friendsProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('My Status', style: context.textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: status.resolve(colorScheme),
            borderRadius: context.radiusLG,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.groups_rounded, color: status.resolve(colorScheme)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.shortLabel,
                      style: context.textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                    Text(
                      'My door is open!',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatusOption(
                label: 'Anyone\ncan come',
                color: colorScheme.statusOpen,
                selected: status == StatusColor.GREEN,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatusOption(
                label: 'Only one\ncan come',
                color: colorScheme.statusLimited,
                selected: status == StatusColor.YELLOW,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatusOption(
                label: 'No one\ncan come',
                color: colorScheme.statusClosed,
                selected: status == StatusColor.RED,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Friends', style: context.textTheme.titleMedium),
        const SizedBox(height: 12),
        friends.when(
          data: (friendList) => Column(
            children: friendList
                .map((friend) => _FriendTile(
                      friend: friend,
                      onRemove: () async {
                        await ref.read(friendsRepositoryProvider).removeFriend(friend.id);
                        ref.invalidate(friendsProvider);
                      },
                    ))
                .toList(),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Text(
            "Couldn't load your friends.",
            style: context.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({required this.friend, required this.onRemove});

  final Friend friend;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final status = friend.status ?? StatusColor.RED;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.surfaceContainerHighest,
          child: Text((friend.displayName?.isNotEmpty ?? false) ? friend.displayName![0] : '?'),
        ),
        title: Text(friend.displayName ?? friend.email ?? 'Unknown'),
        subtitle: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: status.resolve(colorScheme),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(status.shortLabel),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.person_remove_outlined),
          tooltip: 'Remove friend',
          onPressed: onRemove,
        ),
      ),
    );
  }
}
