import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Add_Abook/Add_a_BookView.dart';
import 'package:read_ranger/Features/Home/HomeProvider.dart';
import 'package:read_ranger/Features/Library/BookLibraryView.dart';
import 'package:read_ranger/Features/Settings/SettingsView.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with TickerProviderStateMixin {
  final tabs = [
    Center(
      child: Column(children: [
        Text("Home"),
      ]),
    ),
    Center(
      child: BookLibraryView(),
    ),
    Center(
      child: AddaBookView(),
    ),
    Center(
      child: SettingsView(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: tabs[ref.watch(selectedIndex)],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.read(selectedIndex),
        onTap: (value) {
          if (mounted) {
            ref.read(selectedIndex.notifier).state = value;
          } else {
            throw Exception("Widget is not mounted");
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.library_add_outlined), label: "Add a Book "),
          BottomNavigationBarItem(label: "Settings", icon: Icon(Icons.settings_outlined)),
        ],
      ),
    );
  }
}
