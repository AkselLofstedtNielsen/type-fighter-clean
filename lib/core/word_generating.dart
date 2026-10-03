import 'dart:math';

abstract interface class WordGenerating {
  String getNextWord({Set<String> avoidLetters = const {}});
  bool isPoolEmpty();
  void resetPool();
}

class RandomWordGenerator implements WordGenerating {
  RandomWordGenerator({this.wordLimit = 15, int? seed}) : _random = Random(seed) {
    resetPool();
  }

  final int wordLimit;
  final Random _random;
  List<String> availableWords = [];

  static final wordPool = _wordList.trim().split(RegExp(r'\s+'));

  static const _wordList = '''
    SWIFT CODING APPLE XCODE MOBILE DESIGN PATTERN FRAME FACE KEY
    SCREEN BUTTON GESTURE ANIMATE LAYOUT
    ARRAY ASYNC AWAIT ALIGN ASSET BINARY BRANCH BUILD BUFFER BYTE BUG
    CACHE CLASS CLOUD COMMIT COMPILE CURSOR CANVAS DART DEBUG DEPLOY DRIVER DATA
    ENUM ENGINE EVENT EXPORT ERROR FLUTTER FUNCTION FOLDER FONT FIELD
    GRID GLOBAL GRAPH GIT HASH HEADER HOST HOOK INDEX INPUT ICON IMPORT INSTALL
    JSON JAVA KERNEL KEYBOARD KOTLIN LAMBDA LINUX LOOP LIST LOGIN
    MERGE METHOD MODEL MODULE MOUSE NULL NODE NETWORK NUMBER
    OBJECT OUTPUT OFFSET OPTION PACKAGE PIXEL PLUGIN PROMPT PYTHON PUSH QUERY QUEUE
    RENDER ROUTER RUNTIME REPO RETURN SCROLL SERVER SOCKET STACK STATE STRING SYNTAX SLIDER
    TABLE TERMINAL THREAD TOKEN TOGGLE TYPE UPDATE UPLOAD UNICODE USER
    VECTOR VERSION VIEW VIRTUAL WIDGET WINDOW WEB WIFI XML YIELD YAML ZERO ZOOM ZIP
  ''';

  @override
  String getNextWord({Set<String> avoidLetters = const {}}) {
    final candidates = availableWords.where((word) => !avoidLetters.contains(word[0])).toList();
    final pickFrom = candidates.isEmpty ? availableWords : candidates;

    final word = pickFrom[_random.nextInt(pickFrom.length)];
    availableWords.remove(word);
    return word;
  }

  @override
  bool isPoolEmpty() => availableWords.isEmpty;

  @override
  void resetPool() {
    availableWords = (List.of(wordPool)..shuffle(_random)).take(wordLimit).toList();
  }
}
