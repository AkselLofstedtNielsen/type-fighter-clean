import 'package:material_ui/material_ui.dart';

import '../model/game_state.dart';
import '../theme/app_theme.dart';
import '../utilities/app_storage.dart';
import '../view_model/single_player_vm.dart';
import 'falling_words.dart';
import 'top_bar_view.dart';
import 'typing_view.dart';

class GameView extends StatefulWidget {
  const GameView({super.key, required this.vm});

  final SinglePlayerVM vm;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final AppLifecycleListener lifecycleListener;

  @override
  void initState() {
    super.initState();
    lifecycleListener = AppLifecycleListener(onInactive: widget.vm.pauseGame, onHide: widget.vm.pauseGame);
  }

  @override
  void dispose() {
    lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) vm.quitGame();
      },
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: SafeArea(
            child: ListenableBuilder(
              listenable: vm,
              builder: (context, _) => Stack(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        children: [
                          TopBarView(viewModel: vm),
                          Expanded(child: FallingWords(viewModel: vm)),
                          TypingView(singlePlayerVM: vm),
                        ],
                      ),
                    ),
                  ),
                  if (vm.gameState == .paused || vm.gameWon || vm.gameLost)
                    const ModalBarrier(color: Colors.black54, dismissible: false),
                  if (vm.gameState == .paused) _PauseDialog(vm: vm),
                  if (vm.gameWon || vm.gameLost) _ResultDialog(vm: vm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PauseDialog extends StatelessWidget {
  const _PauseDialog({required this.vm});

  final SinglePlayerVM vm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.pause_circle_rounded),
      title: Text(GameState.paused.displayName),
      content: _DialogButtons(label: 'Resume', onPressed: vm.resumeGame),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  const _ResultDialog({required this.vm});

  final SinglePlayerVM vm;

  String get title {
    if (!vm.gameWon) return 'Better luck next time!';
    return AppStorage.playerName.isEmpty ? 'Good job!' : 'Good job, ${AppStorage.playerName}!';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(vm.gameWon ? Icons.emoji_events_rounded : Icons.heart_broken_rounded),
      title: Text(title),
      content: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              _Stat(label: 'Score', value: '${vm.score}'),
              _Stat(label: 'WPM', value: vm.wordsPerMinute.toStringAsFixed(1)),
              _Stat(label: 'Time', value: vm.elapsedTime.toStringAsFixed(1)),
            ],
          ),
          if (vm.isNewHighScore)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: Chip(avatar: Icon(Icons.star_rounded), label: Text('New best!')),
              ),
            ),
          const SizedBox(height: 24),
          _DialogButtons(label: 'Try again', onPressed: vm.startCountdown),
        ],
      ),
    );
  }
}

class _DialogButtons extends StatelessWidget {
  const _DialogButtons({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        FilledButton(onPressed: onPressed, child: Text(label)),
        const SizedBox(height: 8),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back to homescreen')),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: .min,
      children: [
        Text(value, style: textTheme.headlineSmall?.copyWith(fontWeight: .w800)),
        Text(label, style: textTheme.labelMedium),
      ],
    );
  }
}
