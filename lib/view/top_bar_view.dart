import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../view_model/single_player_vm.dart';

class TopBarView extends StatelessWidget {
  const TopBarView({super.key, required this.viewModel});

  final SinglePlayerVM viewModel;

  String get stringTime => viewModel.elapsedTime.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.titleMedium
        ?.copyWith(fontWeight: .w800, color: colorScheme.primary, fontFeatures: const [FontFeature.tabularFigures()]);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.only(left: 16, right: 4),
      decoration: BoxDecoration(color: AppTheme.topBar.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          for (var life = 0; life < 3; life++)
            Icon(life < viewModel.playerLife ? Icons.favorite : Icons.favorite_border, color: colorScheme.primary),
          const Spacer(),
          Text('Score: ${viewModel.score}', style: style),
          const Spacer(),
          Text('Time: $stringTime', style: style),
          IconButton(
            onPressed: viewModel.gameState == .playing ? viewModel.pauseGame : null,
            icon: const Icon(Icons.pause_rounded),
            tooltip: 'Pause',
          ),
        ],
      ),
    );
  }
}
