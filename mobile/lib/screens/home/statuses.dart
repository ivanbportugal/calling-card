import 'package:calling_card/auth/user.dart';
import 'package:calling_card/auth/user_repository.dart';
import 'package:calling_card/auth/user_status_repository.dart';
import 'package:calling_card/screens/home/status_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_extensions.dart';

class Statuses extends ConsumerWidget {
  const Statuses({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final status = user.status?.color ?? StatusColor.RED;

    Future<void> onStatusUpdate(StatusColor color) async {
      UserStatus newStatus = UserStatus(color);
      await ref.read(userStatusProvider.notifier).updateStatus(newStatus);
      ref.refresh(userProfileProvider.future);
    }

    return Row(
      children: [
        Expanded(
          child: StatusOption(
            label: 'Anyone\ncan come',
            color: colorScheme.statusOpen,
            selected: status == StatusColor.GREEN,
            onTap: () {
              onStatusUpdate(StatusColor.GREEN);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatusOption(
            label: 'Only one\ncan come',
            color: colorScheme.statusLimited,
            selected: status == StatusColor.YELLOW,
            onTap: () {
              onStatusUpdate(StatusColor.YELLOW);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatusOption(
            label: 'No one\ncan come',
            color: colorScheme.statusClosed,
            selected: status == StatusColor.RED,
            onTap: () {
              onStatusUpdate(StatusColor.RED);
            },
          ),
        ),
      ],
    );
  }
}
