import 'package:com.ugurTurker.read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookListStateProvider = StateProvider<List<BookModel>>((ref) {
  return [];
});

final selectedIndex = StateProvider<int>((ref) => 0);
