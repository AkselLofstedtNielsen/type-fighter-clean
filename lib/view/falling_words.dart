import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../view_model/single_player_vm.dart';
import 'word_view.dart';

class FallingWords extends StatelessWidget {
  const FallingWords({super.key, required this.viewModel});

  final SinglePlayerVM viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                for (final word in viewModel.words) WordView(key: ValueKey(word.id), viewModel: viewModel, word: word),
              ],
            ),
          ),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.deadLine,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [BoxShadow(color: AppTheme.deadLine.withValues(alpha: 0.6), blurRadius: 12)],
            ),
          ),
        ],
      ),
    );
  }
}
