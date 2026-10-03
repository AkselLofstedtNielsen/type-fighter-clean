import 'package:material_ui/material_ui.dart';

import '../model/difficulty.dart';
import '../theme/app_theme.dart';
import '../utilities/app_storage.dart';
import '../view_model/single_player_vm.dart';
import 'game_view.dart';
import 'settings_view.dart';

class StartScreenView extends StatefulWidget {
  const StartScreenView({super.key});

  @override
  State<StartScreenView> createState() => _StartScreenViewState();
}

class _StartScreenViewState extends State<StartScreenView> {
  final singlePlayerVM = SinglePlayerVM();

  @override
  void dispose() {
    singlePlayerVM.dispose();
    super.dispose();
  }

  void showSinglePlayer() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => GameView(vm: singlePlayerVM)));
  }

  void showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const SettingsView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: ListenableBuilder(
                listenable: singlePlayerVM,
                builder: (context, _) => Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'TYPE FIGHTER',
                      textAlign: .center,
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: .w900,
                        color: Colors.white,
                        shadows: const [Shadow(color: AppTheme.purple, blurRadius: 10)],
                      ),
                    ),
                    const SizedBox(height: 40),
                    const _SectionTitle('GAME MODES'),
                    ScaleButton(
                      child: FilledButton(onPressed: showSinglePlayer, child: const Text('Single Player')),
                    ),
                    const SizedBox(height: 12),
                    const FilledButton.tonal(onPressed: null, child: Text('Multiplayer')),
                    const SizedBox(height: 40),
                    const _SectionTitle('DIFFICULTY'),
                    SegmentedButton<Difficulty>(
                      segments: [
                        for (final difficulty in Difficulty.values)
                          ButtonSegment(value: difficulty, label: Text(difficulty.displayName)),
                      ],
                      selected: {singlePlayerVM.difficulty},
                      showSelectedIcon: false,
                      onSelectionChanged: (selection) => singlePlayerVM.difficulty = selection.first,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Best: ${AppStorage.highScore(singlePlayerVM.difficulty)}',
                      textAlign: .center,
                      style: textTheme.titleMedium?.copyWith(fontWeight: .w700),
                    ),
                    const Spacer(),
                    Center(
                      child: IconButton.filledTonal(
                        onPressed: showSettings,
                        icon: const Icon(Icons.settings_rounded),
                        iconSize: 28,
                        tooltip: 'Settings',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        textAlign: .center,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: .w800, letterSpacing: 1.5),
      ),
    );
  }
}

class ScaleButton extends StatefulWidget {
  const ScaleButton({super.key, required this.child});

  final Widget child;

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => isPressed = true),
      onPointerUp: (_) => setState(() => isPressed = false),
      onPointerCancel: (_) => setState(() => isPressed = false),
      child: AnimatedScale(
        scale: isPressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}
