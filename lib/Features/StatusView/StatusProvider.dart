import 'package:com.ugurTurker.read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unCompletedBooksProvider = StateProvider<List<BookModel>>((ref) {
  return [];
});
