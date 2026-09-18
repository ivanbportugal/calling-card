import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../friends/friends_repository.dart';
import '../../models/friend.dart';
import 'qr_scan_screen.dart';

Future<void> showAddFriendDialog(BuildContext context, WidgetRef ref) async {
  final sent = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => const _AddFriendDialog(),
  );

  if (sent == true) {
    ref.invalidate(friendRequestsProvider);
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

  Future<void> _scanQr() async {
    final email = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScanScreen()),
    );
    if (email == null) return;

    _controller.text = email;
    await _search();
  }

  Future<void> _search() async {
    final email = _controller.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _status = _SearchStatus.loading;
      _result = null;
    });

    try {
      final friend = await ref
          .read(friendsRepositoryProvider)
          .searchByEmail(email);
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add a friend'),
          IconButton(
            onPressed: _scanQr,
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan QR code',
          ),
        ],
      ),
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
            _SearchStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            _SearchStatus.notFound => const Text(
              'No user found with that email.',
            ),
            _SearchStatus.error => const Text(
              "Something went wrong. Try again.",
            ),
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
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
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
