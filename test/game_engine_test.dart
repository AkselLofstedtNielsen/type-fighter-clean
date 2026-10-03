import 'package:flutter_test/flutter_test.dart';
import 'package:typefighter/core/game_engine.dart';
import 'package:typefighter/model/difficulty.dart';

import 'fixed_word_generator.dart';

void main() {
  late GameEngine engine;

  setUp(() {
    engine = GameEngine(difficulty: .easy, wordGenerating: FixedWordGenerator(['SWIFT', 'SCREEN', 'DART']));
    engine.startGame();
  });

  void type(String text) {
    for (final letter in text.split('')) {
      engine.processUserInput(letter);
    }
  }

  test('starts with one falling word and three lives', () {
    expect(engine.words.map((word) => word.word), ['SWIFT']);
    expect(engine.lives, 3);
  });

  test('spawns a new word every spawn interval until the pool is empty', () {
    engine.updateGameTime(Difficulty.easy.spawnInterval);
    engine.updateGameTime(Difficulty.easy.spawnInterval);
    engine.updateGameTime(Difficulty.easy.spawnInterval);

    expect(engine.words.map((word) => word.word), ['SWIFT', 'SCREEN', 'DART']);
  });

  test('first letter locks the oldest matching word', () {
    engine.updateGameTime(Difficulty.easy.spawnInterval);

    expect(engine.processUserInput('S'), isA<PartialMatch>());
    expect(engine.activeWordId, engine.words.first.id);
    expect(engine.currentTypedWord, 'S');
  });

  test('wrong letter resets the word', () {
    type('SW');

    expect(engine.processUserInput('X'), isA<NoMatch>());
    expect(engine.activeWordId, isNull);
    expect(engine.currentTypedWord, isEmpty);
  });

  test('completing a word removes it and scores length * 10 * multiplier', () {
    engine.difficulty = .hard;
    type('SWIF');

    final result = engine.processUserInput('T');

    expect(result, isA<CompleteMatch>());
    expect((result as CompleteMatch).score, 5 * 10 * 3);
    expect(engine.score, 150);
    expect(engine.words, isEmpty);
    expect(engine.currentTypedWord, isEmpty);
  });

  test('words per minute is based on completed words', () {
    type('SWIFT');
    engine.updateGameTime(30);

    expect(engine.wordsPerMinute, 2.0);
  });

  test('removing the active word resets typing', () {
    type('SW');
    engine.removeWord(engine.words.first.id);

    expect(engine.activeWordId, isNull);
    expect(engine.currentTypedWord, isEmpty);
  });

  test('won when the pool is empty and all words are typed', () {
    type('SWIFT');
    engine.updateGameTime(Difficulty.easy.spawnInterval);
    type('SCREEN');
    expect(engine.isGameWon(), isFalse);

    engine.updateGameTime(Difficulty.easy.spawnInterval);
    type('DART');
    expect(engine.isGameWon(), isTrue);
  });

  test('game over when lives run out', () {
    engine.decrementLives();
    engine.decrementLives();
    expect(engine.isGameOver(), isFalse);

    engine.decrementLives();
    expect(engine.isGameOver(), isTrue);
  });
}
