import 'package:material_ui/material_ui.dart';

import '../animation/highlighted_letter.dart';
import '../model/word.dart';
import '../view_model/single_player_vm.dart';

class WordView extends StatelessWidget {
  const WordView({super.key, required this.viewModel, required this.word});

  final SinglePlayerVM viewModel;
  final Word word;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(word.xPos, -1 + 2 * viewModel.fallingProgress(word)),
      child: HighlightedText(
        word.word,
        matching: viewModel.isActive(word) ? viewModel.userText : '',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: .w800, color: Colors.white),
      ),
    );
  }
}
