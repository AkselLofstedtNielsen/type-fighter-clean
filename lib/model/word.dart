class Word {
  Word({required this.word, required this.xPos});

  static int _nextId = 0;

  final int id = _nextId++;
  final String word;
  final double xPos;

  List<String> get letters => word.split('');

  String get letter => word[0];
}
