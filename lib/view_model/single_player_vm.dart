import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../core/falling_words_controller.dart';
import '../core/game_engine.dart';
import '../core/game_state_machine.dart';
import '../core/word_generating.dart';
import '../model/difficulty.dart';
import '../model/game_state.dart';
import '../model/word.dart';
import '../utilities/app_storage.dart';

class SinglePlayerVM extends ChangeNotifier {
  SinglePlayerVM() {
    stateMachine
      ..onGameStart = _startGameLoop
      ..onGamePause = _stopGameLoop
      ..onGameResume = _resumeGameLoop
      ..onGameWin = (() => _gameEnded(won: true))
      ..onGameLose = (() => _gameEnded(won: false))
      ..onStateChange = ((_) => notifyListeners());

    fallingController.onWordExpired = wordMissed;
  }

  final gameEngine = GameEngine(difficulty: .easy, wordGenerating: RandomWordGenerator());
  late final stateMachine = GameStateMachine(gameEngine: gameEngine);
  final fallingController = FallingWordsController();

  late final _ticker = Ticker(_onTick);
  Duration _lastTick = .zero;

  String userText = '';
  bool gameWon = false;
  bool gameLost = false;
  bool isCountingDown = false;
  bool isNewHighScore = false;
  int wrongLetters = 0;

  GameState get gameState => stateMachine.currentState;
  bool get gameRunning => gameState == .playing || gameState == .paused;
  int get playerLife => gameEngine.lives;
  double get elapsedTime => gameEngine.elapsedTime;
  int get score => gameEngine.score;
  double get wordsPerMinute => gameEngine.wordsPerMinute;
  List<Word> get words => gameEngine.words;

  Difficulty get difficulty => gameEngine.difficulty;
  set difficulty(Difficulty difficulty) {
    gameEngine.difficulty = difficulty;
    notifyListeners();
  }

  bool isActive(Word word) => gameEngine.activeWordId == word.id;

  double fallingProgress(Word word) => fallingController.progress(word, difficulty);

  void tick(double dt) {
    if (gameState != .playing) return;

    gameEngine.updateGameTime(dt);
    fallingController.updateWordAnimations(gameEngine.words, dt, difficulty);
    notifyListeners();
  }

  void testing(String letter) {
    if (gameState != .playing) return;

    switch (gameEngine.processUserInput(letter.toUpperCase())) {
      case NoMatch():
        userText = gameEngine.currentTypedWord;
        wrongLetters += 1;
        _haptic(HapticFeedback.selectionClick);
      case PartialMatch():
        userText = gameEngine.currentTypedWord;
      case CompleteMatch():
        userText = '';
        _haptic(HapticFeedback.lightImpact);
        stateMachine.checkGameStatus();
    }
    notifyListeners();
  }

  void handleBackspace() {
    gameEngine.resetWordTyping();
    userText = '';
    notifyListeners();
  }

  void wordMissed(int wordId) {
    if (gameState != .playing) return;

    gameEngine.removeWord(wordId);
    gameEngine.decrementLives();
    userText = gameEngine.currentTypedWord;
    _haptic(HapticFeedback.heavyImpact);
    checkDead();
  }

  void checkDead() {
    stateMachine.checkGameStatus();
  }

  void startCountdown() {
    if (gameState != .notStarted) stateMachine.resetGame();

    gameWon = false;
    gameLost = false;
    userText = '';
    isCountingDown = true;
    notifyListeners();
  }

  void restartGame() {
    isCountingDown = false;
    isNewHighScore = false;
    gameWon = false;
    gameLost = false;
    userText = '';

    if (gameState != .notStarted) stateMachine.resetGame();
    stateMachine.startGame();
  }

  void pauseGame() {
    if (gameState == .playing) stateMachine.pauseGame();
  }

  void resumeGame() {
    if (gameState == .paused) stateMachine.resumeGame();
  }

  void quitGame() {
    pauseGame();
    if (gameState != .notStarted) stateMachine.resetGame();

    isCountingDown = false;
    gameWon = false;
    gameLost = false;
    userText = '';
    notifyListeners();
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / Duration.microsecondsPerSecond;
    _lastTick = elapsed;
    tick(min(dt, 0.1));
  }

  void _startGameLoop() {
    fallingController.reset();
    _resumeGameLoop();
  }

  void _resumeGameLoop() {
    _lastTick = .zero;
    if (!_ticker.isActive) _ticker.start();
  }

  void _stopGameLoop() => _ticker.stop();

  void _gameEnded({required bool won}) {
    _stopGameLoop();
    gameWon = won;
    gameLost = !won;

    isNewHighScore = score > AppStorage.highScore(difficulty);
    if (isNewHighScore) AppStorage.saveHighScore(difficulty, score);
  }

  void _haptic(Future<void> Function() feedback) {
    if (AppStorage.hapticFeedback) feedback();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
