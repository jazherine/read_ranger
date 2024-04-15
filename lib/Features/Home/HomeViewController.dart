import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'HomeViewController.g.dart';

@riverpod
class IsLight extends _$IsLight {
  @override
  bool build() {
    return true;
  }

  void changeIslight() {
    state = !state;
  }
}
