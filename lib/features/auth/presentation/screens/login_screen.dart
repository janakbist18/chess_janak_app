import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/premium_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _BasicScreenTemplate(
      title: 'Login',
      subtitle: 'Phase 7 will implement email/username login + Google Sign-In.',
      actions: [
        AppButton(
          label: 'Go to Register',
          onPressed: () => context.push(RouteNames.register),
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Open Dashboard (temporary)',
          onPressed: () => context.go(RouteNames.dashboard),
        ),
      ],
    );
  }
}

class _BasicScreenTemplate extends StatelessWidget {
  const _BasicScreenTemplate({
    required this.title,
    required this.subtitle,
    required this.actions,
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: PremiumCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(subtitle, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ...actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}