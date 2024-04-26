import 'package:com.ugurTurker.read_ranger/Features/Settings/SettingsProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationStartInit {
  void Init(WidgetRef ref) {
    SettingsManager.getDarkMode().then((value) {});
  }
}
