import 'package:flutter/material.dart';

import '../../auth/user.dart';
import '../../models/friend.dart';
import '../../theme/status_color_extensions.dart';
import '../../theme/theme_extensions.dart';

class FriendTile extends StatelessWidget {
  const FriendTile({super.key, required this.friend, required this.onRemove});

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
