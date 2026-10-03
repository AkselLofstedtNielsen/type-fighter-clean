import 'package:flutter_test/flutter_test.dart';
import 'package:typefighter/core/falling_words_controller.dart';
import 'package:typefighter/core/word_generating.dart';
import 'package:typefighter/model/word.dart';

void main() {
  test('words fall for the falling duration and then expire once', () {
    final controller = FallingWordsController();
    final words = [Word(word: 'DART', xPos: 0)];
    final expired = <int>[];
    controller.onWordExpired = (wordId) {
      expired.add(wordId);
      words.removeWhere((word) => word.id == wordId);
    };

    controller.updateWordAnimations(words, 4.0, .easy);
    expect(controller.progress(words.first, .easy), 0.5);
    expect(expired, isEmpty);

    final id = words.first.id;
    controller.updateWordAnimations(words, 4.0, .easy);
    controller.updateWordAnimations(words, 4.0, .easy);
    expect(expired, [id]);
    expect(controller.wordTimers, isEmpty);
  });

  test('RandomWordGenerator avoids first letters already on screen', () {
    final generator = RandomWordGenerator(wordLimit: RandomWordGenerator.wordPool.length, seed: 1);

    for (var i = 0; i < 30; i++) {
      final word = generator.getNextWord(avoidLetters: {'S', 'C', 'D'});
      expect(['S', 'C', 'D'], isNot(contains(word[0])));
    }
  });

  test('RandomWordGenerator gives wordLimit unique words per game', () {
    final generator = RandomWordGenerator(wordLimit: 15);
    final words = [for (var i = 0; i < 15; i++) generator.getNextWord()];

    expect(words.toSet(), hasLength(15));
    expect(generator.isPoolEmpty(), isTrue);

    generator.resetPool();
    expect(generator.isPoolEmpty(), isFalse);
  });

  test('word pool has no duplicates', () {
    final pool = RandomWordGenerator.wordPool;
    expect(pool.toSet(), hasLength(pool.length));
  });
}
