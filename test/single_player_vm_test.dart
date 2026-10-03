import 'package:flutter_test/flutter_test.dart';
import 'package:typefighter/model/difficulty.dart';
import 'package:typefighter/model/game_state.dart';
import 'package:typefighter/view_model/single_player_vm.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SinglePlayerVM vm;

  setUp(() => vm = SinglePlayerVM()..restartGame());
  tearDown(() => vm.dispose());

  void type(String text) {
    for (final letter in text.split('')) {
      vm.testing(letter);
    }
  }

  void advance(double seconds) {
    for (var i = 0; i < seconds / 0.25; i++) {
      vm.tick(0.25);
    }
  }

  test('starts a game with one falling word', () {
    expect(vm.gameState, GameState.playing);
    expect(vm.words, hasLength(1));
    expect(vm.playerLife, 3);
  });

  test('lowercase input works and a typed word scores', () {
    final word = vm.words.first.word;

    type(word.substring(0, 2).toLowerCase());
    expect(vm.userText, word.substring(0, 2));

    type(word.substring(2));
    expect(vm.userText, isEmpty);
    expect(vm.score, word.length * 10);
  });

  test('backspace releases the word', () {
    type(vm.words.first.word.substring(0, 2));
    vm.handleBackspace();

    expect(vm.userText, isEmpty);
    expect(vm.isActive(vm.words.first), isFalse);
  });

  test('a missed word costs a life and clears typed letters', () {
    type(vm.words.first.word.substring(0, 2));
    advance(Difficulty.easy.fallingDuration);

    expect(vm.playerLife, 2);
    expect(vm.userText, isEmpty);
  });

  test('three missed words means game over', () {
    advance(30);

    expect(vm.gameState, GameState.lost);
    expect(vm.gameLost, isTrue);
  });

  test('a whole round can be won and played again', () {
    for (var i = 0; i < 400 && vm.gameState == .playing; i++) {
      for (final word in List.of(vm.words)) {
        type(word.word);
      }
      vm.tick(0.25);
    }
    expect(vm.gameState, GameState.won);
    expect(vm.gameWon, isTrue);
    expect(vm.isNewHighScore, isTrue);

    vm.restartGame();
    expect(vm.gameState, GameState.playing);
    expect(vm.gameWon, isFalse);
    expect(vm.isNewHighScore, isFalse);
    expect(vm.score, 0);
  });

  test('wrong letters are counted so the input can shake', () {
    final wrongLetters = vm.wrongLetters;
    vm.testing('#');

    expect(vm.wrongLetters, wrongLetters + 1);
  });

  test('try again from a lost game starts a countdown on a clean board', () {
    advance(30);
    vm.startCountdown();

    expect(vm.isCountingDown, isTrue);
    expect(vm.gameState, GameState.notStarted);
    expect(vm.gameLost, isFalse);
    expect(vm.words, isEmpty);
  });

  test('pause stops the clock and resume continues', () {
    vm.pauseGame();
    vm.tick(1);
    expect(vm.elapsedTime, 0);

    vm.resumeGame();
    vm.tick(1);
    expect(vm.elapsedTime, 1);
  });

  test('quitting resets the game', () {
    vm.quitGame();

    expect(vm.gameState, GameState.notStarted);
    expect(vm.words, isEmpty);
  });
}
