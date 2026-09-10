import 'package:flutter/material.dart';

import '../../auth/user.dart';
import '../../models/friend.dart';
import '../../theme/app_theme.dart';
import '../../theme/status_color_extensions.dart';
import '../../theme/theme_extensions.dart';
import 'status_option.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final status = user.status?.color ?? StatusColor.RED;

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
        ...mockFriends.map(
          (friend) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: Text(friend.name[0]),
              ),
              title: Text(friend.name),
              subtitle: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: friend.status.resolve(colorScheme),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(friend.status.shortLabel),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
