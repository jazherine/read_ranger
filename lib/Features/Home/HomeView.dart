import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:read_ranger/Features/Home/HomeViewController.dart';
import 'package:read_ranger/Products/Colors/colors.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isForward = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this)..value = 0.5;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_isForward) {
      ref.watch(isLightProvider.notifier).changeIslight();
      _controller.animateBack(0.5);
    } else {
      ref.watch(isLightProvider.notifier).changeIslight();

      _controller.animateTo(0);
    }
    _isForward = !_isForward;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
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
          )
        ],
        title: const Text(
          "Read Ranger",
        ),
      ),
      body: const Column(children: []),
    );
  }
}
