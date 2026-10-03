import 'package:typefighter/core/word_generating.dart';

class FixedWordGenerator implements WordGenerating {
  FixedWordGenerator(this.pool);

  final List<String> pool;
  List<String> availableWords = [];

  @override
  String getNextWord({Set<String> avoidLetters = const {}}) => availableWords.removeAt(0);

  @override
  bool isPoolEmpty() => availableWords.isEmpty;

  @override
  void resetPool() => availableWords = List.of(pool);
}
