import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Add_Abook/BookModel.dart';

final bookListStateProvider = StateProvider<List<BookModel>>((ref) {
  return [];
});

final selectedIndex = StateProvider<int>((ref) => 0);
