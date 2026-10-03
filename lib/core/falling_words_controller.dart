import '../model/difficulty.dart';
import '../model/word.dart';

class FallingWordsController {
  final Map<int, double> wordTimers = {};

  void Function(int wordId)? onWordExpired;

  void updateWordAnimations(List<Word> words, double dt, Difficulty difficulty) {
    final wordsToExpire = <int>[];

    for (final word in words) {
      final timer = (wordTimers[word.id] ?? 0) + dt;
      wordTimers[word.id] = timer;

      if (timer >= difficulty.fallingDuration) {
        wordsToExpire.add(word.id);
      }
    }

    wordTimers.removeWhere((wordId, _) => !words.any((word) => word.id == wordId));

    for (final wordId in wordsToExpire) {
      onWordExpired?.call(wordId);
    }
  }

  double progress(Word word, Difficulty difficulty) {
    return ((wordTimers[word.id] ?? 0) / difficulty.fallingDuration).clamp(0.0, 1.0);
  }

  void reset() => wordTimers.clear();
}
