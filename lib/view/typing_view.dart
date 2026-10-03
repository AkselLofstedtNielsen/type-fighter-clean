import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../animation/type_here_animation.dart';
import '../model/game_state.dart';
import '../utilities/custom_text_field.dart';
import '../view_model/single_player_vm.dart';

class TypingView extends StatefulWidget {
  const TypingView({super.key, required this.singlePlayerVM});

  final SinglePlayerVM singlePlayerVM;

  @override
  State<TypingView> createState() => _TypingViewState();
}

class _TypingViewState extends State<TypingView> with SingleTickerProviderStateMixin {
  final focusNode = FocusNode();
  late final shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  late int wrongLetters = widget.singlePlayerVM.wrongLetters;

  @override
  void initState() {
    super.initState();
    widget.singlePlayerVM.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.singlePlayerVM.removeListener(_onChange);
    focusNode.dispose();
    shake.dispose();
    super.dispose();
  }

  void _onChange() {
    final singlePlayerVM = widget.singlePlayerVM;

    if ((singlePlayerVM.isCountingDown || singlePlayerVM.gameState == GameState.playing) && !focusNode.hasFocus) {
      focusNode.requestFocus();
    }
    if (singlePlayerVM.wrongLetters != wrongLetters) {
      wrongLetters = singlePlayerVM.wrongLetters;
      shake.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final singlePlayerVM = widget.singlePlayerVM;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          if (singlePlayerVM.isCountingDown)
            Center(child: TypeHereAnimation(onFinished: singlePlayerVM.restartGame))
          else if (singlePlayerVM.gameState == .notStarted)
            FilledButton(onPressed: singlePlayerVM.startCountdown, child: const Text('Start')),
          if (singlePlayerVM.gameState == .notStarted) const SizedBox(height: 12),
          AnimatedBuilder(
            animation: shake,
            builder: (context, child) => Transform.translate(
              offset: Offset(sin(shake.value * pi * 6) * 10 * (1 - shake.value), 0),
              child: child,
            ),
            child: CustomTextField(
              text: singlePlayerVM.userText,
              focusNode: focusNode,
              onKeyPress: (text) {
                for (final letter in text.split('')) {
                  singlePlayerVM.testing(letter);
                }
              },
              onBackspace: singlePlayerVM.handleBackspace,
            ),
          ),
        ],
      ),
    );
  }
}
