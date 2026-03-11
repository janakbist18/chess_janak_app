import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_notifier.dart';
import '../../../../core/widgets/premium_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeMode,
                title: const Text('System default'),
                onChanged: (value) {
                  if (value != null) notifier.setThemeMode(value);
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeMode,
                title: const Text('Light mode'),
                onChanged: (value) {
                  if (value != null) notifier.setThemeMode(value);
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeMode,
                title: const Text('Dark mode'),
                onChanged: (value) {
                  if (value != null) notifier.setThemeMode(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}