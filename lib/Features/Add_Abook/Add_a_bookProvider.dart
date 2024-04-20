// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final bookModelProvider = StateNotifierProvider<_BookModelNotifier, List<BookModel>>(
  (ref) => _BookModelNotifier(),
);

class _BookModelNotifier extends StateNotifier<List<BookModel>> {
  _BookModelNotifier() : super([]);

  void addBookModel(BookModel bookModel) {
    state = [...state, bookModel];
  }

  void removeBookModel(String bookmodeld) {
    // Again, our state is immutable. So we're making a new list instead of
    // changing the existing list.
    state = state.where((element) => element.id != bookmodeld).toList();
  }
}

class BookModel {
  String? id;
  String? bookName;
  String? description;
  String? imagePath;

  BookModel({this.id, this.bookName, this.description, this.imagePath});

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookName = json['bookName'];
    description = json['description'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookName'] = this.bookName;
    data['description'] = this.description;
    data['imagePath'] = this.imagePath;
    return data;
  }

  BookModel copyWith({
    String? id,
    String? bookName,
    String? description,
    String? imagePath,
  }) {
    return BookModel(
      id: id ?? this.id,
      bookName: bookName ?? this.bookName,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  bool operator ==(covariant BookModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.bookName == bookName &&
        other.description == description &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^ bookName.hashCode ^ description.hashCode ^ imagePath.hashCode;
  }
}
