import 'dart:math';

import '../model/difficulty.dart';
import '../model/word.dart';
import '../round_to_decimal.dart';
import 'word_generating.dart';

sealed class WordMatchResult {}

class NoMatch extends WordMatchResult {}

class PartialMatch extends WordMatchResult {
  PartialMatch({required this.wordId, required this.progress});

  final int wordId;
  final double progress;
}

class CompleteMatch extends WordMatchResult {
  CompleteMatch({required this.wordId, required this.score});

  final int wordId;
  final int score;
}

class GameEngine {
  GameEngine({required this.difficulty, required this.wordGenerating});

  Difficulty difficulty;
  final WordGenerating wordGenerating;

  final List<Word> words = [];
  int score = 0;
  int lives = 3;
  double elapsedTime = 0;
  double wordsPerMinute = 0;
  String currentTypedWord = '';
  int? activeWordId;

  int _letterPosition = 0;
  int _wordsCompleted = 0;
  double _lastSpawnTime = 0;

  static const xPositions = [-0.9, -0.7, -0.5, -0.3, -0.1, 0.1, 0.3, 0.5, 0.7, 0.9];
  final _random = Random();

  void startGame() {
    resetGameState();
    wordGenerating.resetPool();
    spawnWord();
  }

  void resetGameState() {
    words.clear();
    score = 0;
    lives = 3;
    elapsedTime = 0;
    wordsPerMinute = 0;
    _wordsCompleted = 0;
    _lastSpawnTime = 0;
    resetWordTyping();
  }

  void updateGameTime(double dt) {
    elapsedTime += dt;

    if (_wordsCompleted > 0 && elapsedTime > 0) {
      wordsPerMinute = (_wordsCompleted / (elapsedTime / 60)).roundToDecimal(1);
    }

    if (elapsedTime - _lastSpawnTime >= difficulty.spawnInterval) {
      spawnWord();
    }
  }

  void spawnWord() {
    if (wordGenerating.isPoolEmpty()) return;

    final newWord = wordGenerating.getNextWord(avoidLetters: {for (final word in words) word.letter});
    final xPos = xPositions[_random.nextInt(xPositions.length)];

    words.add(Word(word: newWord, xPos: xPos));
    _lastSpawnTime = elapsedTime;
  }

  void removeWord(int id) {
    words.removeWhere((word) => word.id == id);
    if (activeWordId == id) {
      resetWordTyping();
    }
  }

  WordMatchResult processUserInput(String letter) {
    final activeId = activeWordId;
    if (activeId != null) {
      return _continueTypingWord(activeId, letter);
    } else {
      return _startTypingNewWord(letter);
    }
  }

  WordMatchResult _startTypingNewWord(String letter) {
    final matchingWord = words.where((word) => word.letter == letter).firstOrNull;
    if (matchingWord == null) return NoMatch();

    activeWordId = matchingWord.id;
    _letterPosition = 1;
    currentTypedWord = letter;

    return PartialMatch(wordId: matchingWord.id, progress: 1 / matchingWord.word.length);
  }

  WordMatchResult _continueTypingWord(int wordId, String letter) {
    final word = words.where((word) => word.id == wordId).firstOrNull;
    if (word == null || _letterPosition >= word.word.length) return NoMatch();

    final letters = word.letters;

    if (letters[_letterPosition] == letter) {
      _letterPosition += 1;
      currentTypedWord += letter;

      final progress = _letterPosition / letters.length;

      if (_letterPosition == letters.length) {
        final wordScore = _calculateScore(word);
        removeWord(wordId);
        _wordsCompleted += 1;
        score += wordScore;
        return CompleteMatch(wordId: wordId, score: wordScore);
      }

      return PartialMatch(wordId: wordId, progress: progress);
    } else {
      resetWordTyping();
      return NoMatch();
    }
  }

  void resetWordTyping() {
    activeWordId = null;
    _letterPosition = 0;
    currentTypedWord = '';
  }

  int _calculateScore(Word word) => word.word.length * 10 * difficulty.multiplier;

  void decrementLives() {
    lives -= 1;
  }

  bool isGameOver() => lives <= 0;

  bool isGameWon() => words.isEmpty && wordGenerating.isPoolEmpty();
}
