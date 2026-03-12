import 'package:flutter/material.dart';

/// Reusable empty state widget
class EmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? icon;
  final Widget? action;
  final double iconSize;

  const EmptyState({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.action,
    this.iconSize = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            SizedBox(width: iconSize, height: iconSize, child: icon)
          else
            Icon(Icons.inbox, size: iconSize, color: Colors.grey),
          const SizedBox(height: 16),
          if (title != null)
            Text(title!, style: Theme.of(context).textTheme.titleLarge),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    );
  }
}
