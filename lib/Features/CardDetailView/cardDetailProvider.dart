import 'package:flutter_riverpod/flutter_riverpod.dart';

final onSessionProvider = StateProvider<bool>((ref) {
  return false;
});

final durationProvider = StateProvider<Duration>((ref) {
  return Duration();
});
