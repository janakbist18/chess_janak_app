import 'package:flutter/material.dart';

/// Auth header widget
class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthHeader({Key? key, required this.title, this.subtitle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.chess, size: 60, color: Theme.of(context).primaryColor),
        const SizedBox(height: 24),
        Text(title, style: Theme.of(context).textTheme.displaySmall),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
