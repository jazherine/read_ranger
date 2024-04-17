import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'SettingsProvider.g.dart';

@riverpod
class IsLight extends _$IsLight {
  @override
  bool build() {
    return true;
  }

  Future<void> changeIslight() async {
    state = !state;
    final isLight = ref.read(isLightProvider.notifier).state;
    await SettingsManager.setDarkMode(isLight);
  }

  void Init() {
    SettingsManager.getDarkMode().then((value) {
      state = value;
    });
  }
}

class SettingsManager {
  static const String _keyDarkMode = 'darkMode';

  static Future<bool> getDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false; // Varsayılan değer olarak false
  }

  static Future<void> setDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }
}
