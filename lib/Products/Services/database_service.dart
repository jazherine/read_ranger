import 'package:com.ugurTurker.read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static late Isar isar;
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([BookModelSchema], directory: dir.path);
  }

  Future<void> addBookModels(BookModel bookModel) async {
    isar.writeTxn(() => isar.bookModels.put(bookModel));
  }

  Future<List<BookModel>> fetchBooksUncompletedModels() async {
    return await isar.bookModels.where().filter().isCompletedEqualTo(false).findAll();
  }

  Future<List<BookModel>> fetchBookscompletedModels() async {
    return await isar.bookModels.where().filter().isCompletedEqualTo(true).findAll();
  }

  updateCompletedBookModels({required int id}) async {
    final existingbook = await isar.bookModels.get(id);
    if (existingbook != null) {
      existingbook.isCompleted = true;
      isar.writeTxn(() => isar.bookModels.put(existingbook));
    }
  }

  Future<void> updateDurationBookModels({required int id, required Duration duration}) async {
    final existingbook = await isar.bookModels.get(id);
    if (existingbook != null) {
      existingbook.durationSeconds = duration.inSeconds;
      isar.writeTxn(() => isar.bookModels.put(existingbook));
    }
  }

  Future<void> deleteBookModels(int id) async {
    isar.writeTxn(() => isar.bookModels.delete(id));
  }
}
