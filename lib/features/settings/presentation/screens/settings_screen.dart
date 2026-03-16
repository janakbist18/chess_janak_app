import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_notifier.dart';

/// Settings Screen with Preferences and Customization
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _boardTheme = 0; // 0: Classic, 1: Dark, 2: Nature
  bool _showLegalMoves = true;
  bool _highlightLastMove = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: isMobile
          ? _buildMobileLayout(themeMode)
          : _buildDesktopLayout(themeMode),
    );
  }

  Widget _buildMobileLayout(ThemeMode themeMode) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildSection('Display', [
          _buildThemeSettings(themeMode),
          _buildTile(
            'Board Theme',
            _getBoardThemeName(_boardTheme),
            Icons.palette,
            onTap: _showBoardThemeDialog,
          ),
        ]),
        _buildSection('Game Settings', [
          _buildSwitchTile(
            'Show Legal Moves',
            'Highlight possible moves',
            _showLegalMoves,
            (value) => setState(() => _showLegalMoves = value),
          ),
          _buildSwitchTile(
            'Highlight Last Move',
            'Show last played move',
            _highlightLastMove,
            (value) => setState(() => _highlightLastMove = value),
          ),
        ]),
        _buildSection('Notifications', [
          _buildSwitchTile(
            'Sound Effects',
            'Enable game sounds',
            _soundEnabled,
            (value) => setState(() => _soundEnabled = value),
          ),
          _buildSwitchTile(
            'Vibration',
            'Haptic feedback',
            _vibrationEnabled,
            (value) => setState(() => _vibrationEnabled = value),
          ),
        ]),
        _buildSection('Account', [
          _buildTile(
            'Username',
            'YourChessName',
            Icons.person,
            onTap: _showChangeUsernameDialog,
          ),
          _buildTile(
            'Privacy Setting',
            'Public Profile',
            Icons.visibility,
          ),
        ]),
        _buildSection('About', [
          _buildTile(
            'App Version',
            '1.0.0',
            Icons.info,
          ),
          _buildTile(
            'Terms of Service',
            'Read',
            Icons.description,
          ),
        ]),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeMode themeMode) {
    return Row(
      children: [
        // Sidebar
        SizedBox(
          width: 250,
          child: Container(
            color: Colors.grey[100],
            child: ListView(
              children: [
                const SizedBox(height: 16),
                _buildNavItem('Display'),
                _buildNavItem('Game Settings'),
                _buildNavItem('Account'),
              ],
            ),
          ),
        ),
        // Main content
        Expanded(
          child: Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(24),
            child: _buildDesktopContent(themeMode),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildDesktopContent(ThemeMode themeMode) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          _buildDesktopSection('Display Settings', [
            _buildThemeSettings(themeMode),
            _buildTile(
              'Board Theme',
              _getBoardThemeName(_boardTheme),
              Icons.palette,
              onTap: _showBoardThemeDialog,
            ),
          ]),
          _buildDesktopSection('Game Preferences', [
            _buildSwitchTile(
              'Show Legal Moves',
              'Highlight all possible moves while thinking',
              _showLegalMoves,
              (value) => setState(() => _showLegalMoves = value),
            ),
            _buildSwitchTile(
              'Highlight Last Move',
              'Display the last move played with highlighting',
              _highlightLastMove,
              (value) => setState(() => _highlightLastMove = value),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildThemeSettings(ThemeMode themeMode) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          value: ThemeMode.system,
          groupValue: themeMode,
          title: const Text('System default'),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeModeProvider.notifier).setThemeMode(value);
            }
          },
          // Radio value change handled via provider
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.light,
          groupValue: themeMode,
          title: const Text('Light mode'),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeModeProvider.notifier).setThemeMode(value);
            }
          },
          // Radio value change handled via provider
        ),
        RadioListTile<ThemeMode>(
          value: ThemeMode.dark,
          groupValue: themeMode,
          title: const Text('Dark mode'),
          onChanged: (value) {
            if (value != null) {
              ref.read(themeModeProvider.notifier).setThemeMode(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildDesktopSection(String title, List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTile(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  String _getBoardThemeName(int theme) {
    const themes = ['Classic', 'Dark', 'Nature'];
    return themes[theme];
  }

  void _showBoardThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Board Theme'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              _buildThemeOption(
                  'Classic', 0, Colors.amber[700], Colors.amber[200]),
              const SizedBox(height: 8),
              _buildThemeOption('Dark', 1, Colors.grey[800], Colors.grey[400]),
              const SizedBox(height: 8),
              _buildThemeOption(
                  'Nature', 2, Colors.green[800], Colors.lime[200]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
      String name, int value, Color? darkColor, Color? lightColor) {
    return GestureDetector(
      onTap: () {
        setState(() => _boardTheme = value);
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: _boardTheme == value ? Colors.blue : Colors.grey,
                width: _boardTheme == value ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  width: 30,
                  height: 30,
                  child: Container(color: lightColor),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  width: 30,
                  height: 30,
                  child: Container(color: darkColor),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: 30,
                  height: 30,
                  child: Container(color: darkColor),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  width: 30,
                  height: 30,
                  child: Container(color: lightColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(name),
        ],
      ),
    );
  }

  void _showChangeUsernameDialog() {
    final controller = TextEditingController(text: 'YourChessName');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            label: Text('New Username'),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Username updated successfully')),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
