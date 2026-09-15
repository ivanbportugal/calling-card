import 'package:calling_card/auth/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showEditProfileDialog(BuildContext context, WidgetRef ref) async {
  final currentUser = ref.read(userProfileProvider).value;
  if (currentUser == null) return;

  await showDialog(
    context: context,
    builder: (context) {
      return HookBuilder(
        builder: (context) {
          final controller = useTextEditingController(text: currentUser.displayName);

          return AlertDialog(
            title: const Text('Edit Display Name'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final newName = controller.text.trim();
                  if (newName.isEmpty) return;

                  Navigator.of(context).pop(); // close first
                  final updatedUser = currentUser.copyWith(displayName: newName);
                  await ref
                      .read(userProfileProvider.notifier)
                      .updateProfile(updatedUser);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
