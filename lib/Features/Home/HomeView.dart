import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Settings/SettingsView.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with TickerProviderStateMixin {
  var _selectedIndex = 0;

  final tabs = [
    Center(
      child: Column(children: [
        Text("Home"),
      ]),
    ),
    Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Dark mode"), SettingsView()],
    ))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedFontSize: 15,
        unselectedFontSize: 12,
        selectedIconTheme: IconThemeData(size: 25),
        unselectedIconTheme: IconThemeData(size: 20),
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(label: "Settings", icon: Icon(Icons.settings_outlined)),
        ],
      ),
    );
  }
}
