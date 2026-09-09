import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/user.dart';
import '../auth/user_repository.dart';
import '../models/friend.dart';
import '../theme/app_theme.dart';
import '../theme/status_color_extensions.dart';
import '../theme/theme_extensions.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(profileProvider.future),
        child: profile.when(
          data: (user) => _HomeContent(user: user),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ErrorState(onRetry: () => ref.invalidate(profileProvider)),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Couldn't load your profile.",
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.user});

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
              child: _StatusOption(
                label: 'Anyone\ncan come',
                color: colorScheme.statusOpen,
                selected: status == StatusColor.GREEN,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatusOption(
                label: 'Only one\ncan come',
                color: colorScheme.statusLimited,
                selected: status == StatusColor.YELLOW,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatusOption(
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

class _StatusOption extends StatelessWidget {
  const _StatusOption({required this.label, required this.color, required this.selected});

  final String label;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: context.radiusMD,
        border: selected ? Border.all(color: color, width: 2) : null,
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 16, backgroundColor: color),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: context.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
