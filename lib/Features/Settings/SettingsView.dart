import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:read_ranger/Features/Settings/SettingsProvider.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _islight = ref.read(isLightProvider.notifier);

    _controller = AnimationController(vsync: this)..value = _islight.state ? 0.5 : 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    ref.watch(isLightProvider.notifier).changeIslight();
    final _isLight = ref.read(isLightProvider.notifier).state;
    if (_isLight) {
      _controller.animateBack(0.5);
    } else if (_isLight == false) {
      _controller.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              "Settings",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Text("Dark Mode "),
          ),
          InkWell(
            onTap: () {
              _toggleAnimation();
            },
            child: Lottie.asset(
              'assets/lottie/LottieThemeChanger.json',
              width: 50,
              controller: _controller,
              onLoaded: (p0) {
                _controller.duration = p0.duration;
              },
            ),
          ),
        ],
      ),
    );
  }
}
