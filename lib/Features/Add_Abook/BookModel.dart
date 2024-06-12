// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

part 'BookModel.g.dart';

@collection
class BookModel {
  Id id = Isar.autoIncrement;
  String? bookName;
  String? description;
  String? imagePath;
  String? bookPages;
  bool? isCompleted;
  int? durationSeconds;
  BookModel(
      {this.bookName, this.description, this.bookPages, this.imagePath, Duration? duration, this.isCompleted = false}) {
    if (duration != null) {
      this.durationSeconds = duration.inSeconds;
    }
  }
}
