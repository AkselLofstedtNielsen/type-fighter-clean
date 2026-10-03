import 'package:material_ui/material_ui.dart';

import '../utilities/app_storage.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final playerName = TextEditingController(text: AppStorage.playerName);
  bool hapticFeedback = AppStorage.hapticFeedback;

  @override
  void dispose() {
    playerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 12, 8),
            child: Row(
              children: [
                Text('Settings', style: textTheme.headlineSmall?.copyWith(fontWeight: .w800)),
                const Spacer(),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
              ],
            ),
          ),
          const _SectionHeader('Player'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: playerName,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Player Name'),
              onChanged: (value) => AppStorage.playerName = value.trim(),
            ),
          ),
          const _SectionHeader('Game Settings'),
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            value: hapticFeedback,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            onChanged: (value) {
              setState(() => hapticFeedback = value);
              AppStorage.hapticFeedback = value;
            },
          ),
          const _SectionHeader('About'),
          const ListTile(
            title: Text('Version'),
            trailing: Text('1.0.0'),
            contentPadding: EdgeInsets.symmetric(horizontal: 24),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: .w800, letterSpacing: 1.2),
      ),
    );
  }
}
