import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Add_Abook/BookModel.dart';

import 'package:read_ranger/Features/Home/HomeView.dart';
import 'package:read_ranger/Features/Library/BookLibraryView.dart';
import 'package:read_ranger/Features/Settings/SettingsProvider.dart';
import 'package:read_ranger/Features/Settings/SettingsView.dart';
import 'package:read_ranger/Products/Services/database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    ref.watch(isLightProvider.notifier).Init();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/settings": (context) => SettingsView(),
        "/home": (context) => HomeView(),
        "/library": (context) => BookLibraryView(),
      },
      home: HomeView(),
      theme: ref.watch(isLightProvider)
          ? ThemeData.light().copyWith(
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.black,
                selectedIconTheme: IconThemeData(size: 25),
                selectedLabelStyle: TextStyle(fontSize: 15),
                unselectedLabelStyle: TextStyle(fontSize: 15),
                unselectedIconTheme: IconThemeData(size: 20),
              ),
            )
          : ThemeData.dark().copyWith(
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.white,
                selectedIconTheme: IconThemeData(size: 25),
                selectedLabelStyle: TextStyle(fontSize: 15),
                unselectedLabelStyle: TextStyle(fontSize: 15),
                unselectedIconTheme: IconThemeData(size: 20),
              ),
            ),
    );
  }
}
