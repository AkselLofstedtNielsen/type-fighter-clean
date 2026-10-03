import 'package:flutter_test/flutter_test.dart';
import 'package:typefighter/core/game_engine.dart';
import 'package:typefighter/core/game_state_machine.dart';
import 'package:typefighter/model/difficulty.dart';
import 'package:typefighter/model/game_state.dart';

import 'fixed_word_generator.dart';

void main() {
  late GameEngine engine;
  late GameStateMachine stateMachine;
  late List<String> events;

  setUp(() {
    engine = GameEngine(difficulty: .easy, wordGenerating: FixedWordGenerator(['DART', 'FLUTTER', 'WIDGET']));
    events = [];
    stateMachine = GameStateMachine(gameEngine: engine)
      ..onGameStart = (() => events.add('start'))
      ..onGamePause = (() => events.add('pause'))
      ..onGameResume = (() => events.add('resume'))
      ..onGameWin = (() => events.add('win'))
      ..onGameLose = (() => events.add('lose'));
  });

  test('start, pause and resume', () {
    stateMachine.startGame();
    expect(stateMachine.currentState, GameState.playing);
    expect(engine.words, hasLength(1));

    stateMachine.pauseGame();
    expect(stateMachine.currentState, GameState.paused);

    stateMachine.resumeGame();
    expect(stateMachine.currentState, GameState.playing);
    expect(events, ['start', 'pause', 'resume']);
  });

  test('invalid transitions are ignored', () {
    stateMachine.pauseGame();
    expect(stateMachine.currentState, GameState.notStarted);

    stateMachine.startGame();
    stateMachine.resetGame();
    expect(stateMachine.currentState, GameState.playing);
  });

  test('lost when lives run out', () {
    stateMachine.startGame();
    engine.lives = 0;
    stateMachine.checkGameStatus();

    expect(stateMachine.currentState, GameState.lost);
    expect(events.last, 'lose');
  });

  test('can try again after a game is over', () {
    stateMachine.startGame();
    engine.lives = 0;
    stateMachine.checkGameStatus();

    stateMachine.resetGame();
    stateMachine.startGame();

    expect(stateMachine.currentState, GameState.playing);
    expect(engine.lives, 3);
    expect(engine.words.map((word) => word.word), ['DART']);
  });

  test('a whole round can be played to victory', () {
    stateMachine.startGame();

    for (var tick = 0; tick < 100 && stateMachine.currentState == .playing; tick++) {
      for (final word in List.of(engine.words)) {
        for (final letter in word.letters) {
          engine.processUserInput(letter);
        }
        stateMachine.checkGameStatus();
      }
      engine.updateGameTime(0.5);
    }

    expect(stateMachine.currentState, GameState.won);
    expect(engine.score, (4 + 7 + 6) * 10 * Difficulty.easy.multiplier);
  });
}
