import 'package:flutter/material.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Sound'),
            trailing: Switch(value: true, onChanged: null),
          ),
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(value: true, onChanged: null),
          ),
          ListTile(title: Text('Theme'), trailing: Text('Light')),
        ],
      ),
    );
  }
}
