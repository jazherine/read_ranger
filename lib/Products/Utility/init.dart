import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Settings/SettingsProvider.dart';

class ApplicationStartInit {
  void Init(WidgetRef ref) {
    SettingsManager.getDarkMode().then((value) {});
  }
}
