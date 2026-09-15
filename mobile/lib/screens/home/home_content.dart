import 'package:calling_card/screens/home/statuses.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/user.dart';
import '../../friends/friends_repository.dart';
import '../../theme/status_color_extensions.dart';
import '../../theme/theme_extensions.dart';
import 'friend_tile.dart';

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
        Statuses(user: user),
        const SizedBox(height: 24),
        Text('Friends', style: context.textTheme.titleMedium),
        const SizedBox(height: 12),
        friends.when(
          data: (friendList) => Column(
            children: friendList
                .map((friend) => FriendTile(
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
