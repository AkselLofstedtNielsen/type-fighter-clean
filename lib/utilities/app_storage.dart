import 'package:shared_preferences/shared_preferences.dart';

import '../model/difficulty.dart';

class AppStorage {
  static SharedPreferencesWithCache? _prefs;

  static Future<void> load() async {
    _prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
  }

  static String get playerName => _prefs?.getString('playerName') ?? '';
  static set playerName(String value) => _prefs?.setString('playerName', value);

  static bool get hapticFeedback => _prefs?.getBool('hapticFeedback') ?? true;
  static set hapticFeedback(bool value) => _prefs?.setBool('hapticFeedback', value);

  static int highScore(Difficulty difficulty) => _prefs?.getInt('highScore_${difficulty.name}') ?? 0;

  static void saveHighScore(Difficulty difficulty, int score) => _prefs?.setInt('highScore_${difficulty.name}', score);
}
