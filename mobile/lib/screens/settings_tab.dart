import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth_providers.dart';
import '../auth/user_repository.dart';
import '../models/friend.dart';
import '../theme/status_color_extensions.dart';
import '../theme/theme_extensions.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
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
}
