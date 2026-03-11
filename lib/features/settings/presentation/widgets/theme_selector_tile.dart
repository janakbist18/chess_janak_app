import 'package:flutter/material.dart';

/// Theme selector tile widget
class ThemeSelectorTile extends StatelessWidget {
  final String currentOption;
  final ValueChanged<String?> onChanged;

  const ThemeSelectorTile({
    Key? key,
    required this.currentOption,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Theme Mode'),
      trailing: DropdownButton<String>(
        value: currentOption,
        items: ['light', 'dark', 'system']
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(option.toUpperCase()),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
