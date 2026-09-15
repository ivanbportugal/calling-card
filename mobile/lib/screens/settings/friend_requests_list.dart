import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../friends/friends_repository.dart';
import '../../models/friend_request.dart';
import '../../theme/theme_extensions.dart';

class FriendRequestsList extends ConsumerWidget {
  const FriendRequestsList({super.key, required this.requests});

  final AsyncValue<FriendRequests> requests;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return requests.when(
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
                  title: Text(
                    request.user.displayName ?? request.user.email ?? 'Unknown',
                  ),
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
                  title: Text(
                    request.user.displayName ?? request.user.email ?? 'Unknown',
                  ),
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
    );
  }

  Future<void> _acceptRequest(
    BuildContext context,
    WidgetRef ref,
    FriendRequest request,
  ) async {
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

  Future<void> _declineRequest(
    BuildContext context,
    WidgetRef ref,
    FriendRequest request,
  ) async {
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
