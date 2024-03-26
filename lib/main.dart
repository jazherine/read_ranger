import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:read_ranger/Constants/Colors/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              child: Lottie.asset('assets/lottie/LottieThemeChanger.json'),
            )
          ],
          backgroundColor: ThemeColors.primaryColor,
          title: const Text(
            "Read Ranger",
          ),
        ),
        body: const Column(children: []),
      ),
    );
  }
}
