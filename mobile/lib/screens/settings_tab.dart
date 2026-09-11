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
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const _AddFriendDialog(),
    );

    if (sent == true) {
      ref.invalidate(friendRequestsProvider);
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

enum _SearchStatus { idle, loading, found, notFound, error }

class _AddFriendDialog extends ConsumerStatefulWidget {
  const _AddFriendDialog();

  @override
  ConsumerState<_AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends ConsumerState<_AddFriendDialog> {
  final _controller = TextEditingController();
  _SearchStatus _status = _SearchStatus.idle;
  Friend? _result;
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final email = _controller.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _status = _SearchStatus.loading;
      _result = null;
    });

    try {
      final friend = await ref.read(friendsRepositoryProvider).searchByEmail(email);
      setState(() {
        _result = friend;
        _status = friend != null ? _SearchStatus.found : _SearchStatus.notFound;
      });
    } catch (_) {
      setState(() => _status = _SearchStatus.error);
    }
  }

  Future<void> _sendRequest() async {
    final friend = _result;
    if (friend == null) return;

    setState(() => _sending = true);
    try {
      await ref.read(friendsRepositoryProvider).sendFriendRequest(friend.id);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      setState(() {
        _sending = false;
        _status = _SearchStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a friend'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Friend's email"),
            onSubmitted: (_) => _search(),
          ),
          const SizedBox(height: 16),
          switch (_status) {
            _SearchStatus.idle => const SizedBox.shrink(),
            _SearchStatus.loading => const Center(child: CircularProgressIndicator()),
            _SearchStatus.notFound => const Text('No user found with that email.'),
            _SearchStatus.error => const Text("Something went wrong. Try again."),
            _SearchStatus.found => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(_result!.displayName ?? _result!.email ?? 'Unknown'),
                subtitle: Text(_result!.email ?? ''),
              ),
          },
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        if (_status == _SearchStatus.found)
          TextButton(
            onPressed: _sending ? null : _sendRequest,
            child: const Text('Send request'),
          )
        else
          TextButton(
            onPressed: _status == _SearchStatus.loading ? null : _search,
            child: const Text('Search'),
          ),
      ],
    );
  }
}
