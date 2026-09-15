import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../friends/friends_repository.dart';
import '../../models/friend.dart';
import '../../theme/theme_extensions.dart';
import '../home/friend_tile.dart';

class FriendsList extends ConsumerWidget {
  const FriendsList({super.key, required this.friends});

  final AsyncValue<List<Friend>> friends;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return friends.when(
      data: (friendList) => friendList.isEmpty
          ? Text(
              'No friends yet.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            )
          : Column(
              children: friendList
                  .map(
                    (friend) => FriendTile(
                      friend: friend,
                      onRemove: () => _removeFriend(context, ref, friend),
                    ),
                  )
                  .toList(),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Text(
        "Couldn't load your friends.",
        style: context.textTheme.bodyLarge,
      ),
    );
  }

  Future<void> _removeFriend(
    BuildContext context,
    WidgetRef ref,
    Friend friend,
  ) async {
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
}
