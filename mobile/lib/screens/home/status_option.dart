import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';

class StatusOption extends StatelessWidget {
  const StatusOption({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
