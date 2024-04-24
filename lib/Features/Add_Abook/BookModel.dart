// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

part 'BookModel.g.dart';

@collection
class BookModel {
  Id id = Isar.autoIncrement;
  String? bookName;
  String? description;
  String? imagePath;
  int? durationMinutes;
  BookModel({this.bookName, this.description, this.imagePath, Duration? duration}) {
    if (duration != null) {
      this.durationMinutes = duration.inMinutes;
    }
  }
}
