import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/user.dart';
import '../../theme/theme_extensions.dart';
import 'edit_profile_dialog.dart';
import 'my_qr_dialog.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key, required this.profile});

  final AsyncValue<User> profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;

    return profile.when(
      data: (user) => Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: colorScheme.surfaceContainerHighest,
            backgroundImage: user.photoUrl != null
                ? NetworkImage(user.photoUrl!)
                : null,
            child: user.photoUrl != null
                ? Text(
                    user.displayName != null ? user.displayName![0] : '?',
                    style: context.textTheme.headlineSmall,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName != null ? user.displayName! : '',
                  style: context.textTheme.titleLarge,
                ),
                Text(
                  user.email,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => showMyQrDialog(context, user.email, colorScheme),
            icon: const Icon(Icons.qr_code),
          ),
          IconButton(
            onPressed: () {
              showEditProfileDialog(context, ref);
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Text(
        "Couldn't load your name.",
        style: context.textTheme.bodyLarge,
      ),
    );
  }
}
