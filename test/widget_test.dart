import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:typefighter/main.dart';
import 'package:typefighter/model/difficulty.dart';
import 'package:typefighter/model/game_state.dart';
import 'package:typefighter/view/game_view.dart';

void main() {
  testWidgets('start a game and type the falling word', (tester) async {
    await tester.pumpWidget(const TypeFighterApp());

    await tester.tap(find.text('Single Player'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start'));
    await tester.pump();
    expect(find.text('3'), findsOneWidget);

    for (var second = 0; second < 3; second++) {
      await tester.pump(const Duration(seconds: 1));
    }

    final vm = tester.widget<GameView>(find.byType(GameView)).vm;
    expect(vm.gameState, GameState.playing);
    final word = vm.words.first.word;

    await tester.enterText(find.byType(TextField), word);
    await tester.pump();

    expect(find.text('Score: ${word.length * 10}'), findsOneWidget);
  });

  testWidgets('pick difficulty and open settings', (tester) async {
    await tester.pumpWidget(const TypeFighterApp());

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Haptic Feedback'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Haptic Feedback'), findsNothing);

    await tester.tap(find.text('Hard'));
    await tester.tap(find.text('Single Player'));
    await tester.pumpAndSettle();

    expect(tester.widget<GameView>(find.byType(GameView)).vm.difficulty, Difficulty.hard);
  });
}
