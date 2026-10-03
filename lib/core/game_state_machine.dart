import 'dart:developer';

import '../model/game_state.dart';
import 'game_engine.dart';

class GameStateMachine {
  GameStateMachine({required this.gameEngine});

  final GameEngine gameEngine;

  GameState _currentState = .notStarted;
  GameState get currentState => _currentState;

  void Function()? onGameStart;
  void Function()? onGamePause;
  void Function()? onGameResume;
  void Function()? onGameWin;
  void Function()? onGameLose;
  void Function(GameState state)? onStateChange;

  void transition({required GameState to}) {
    if (!_isValidTransition(from: _currentState, to: to)) {
      log('Invalid state transition: $_currentState -> $to');
      return;
    }

    _performEntryActions(to);

    _currentState = to;
    onStateChange?.call(to);
  }

  bool _isValidTransition({required GameState from, required GameState to}) {
    return switch ((from, to)) {
      (.notStarted, .playing) ||
      (.playing, .paused) ||
      (.paused, .playing) ||
      (.playing, .won) ||
      (.playing, .lost) ||
      (.won, .notStarted) ||
      (.lost, .notStarted) ||
      (.paused, .notStarted) => true,
      _ => false,
    };
  }

  void _performEntryActions(GameState state) {
    switch (state) {
      case .notStarted:
        gameEngine.resetGameState();

      case .playing:
        if (_currentState == .notStarted) {
          gameEngine.startGame();
          onGameStart?.call();
        } else if (_currentState == .paused) {
          onGameResume?.call();
        }

      case .paused:
        onGamePause?.call();

      case .won:
        onGameWin?.call();

      case .lost:
        onGameLose?.call();
    }
  }

  void startGame() => transition(to: .playing);

  void pauseGame() => transition(to: .paused);

  void resumeGame() => transition(to: .playing);

  void resetGame() => transition(to: .notStarted);

  void checkGameStatus() {
    if (_currentState != .playing) return;

    if (gameEngine.isGameOver()) {
      transition(to: .lost);
    } else if (gameEngine.isGameWon()) {
      transition(to: .won);
    }
  }
}
