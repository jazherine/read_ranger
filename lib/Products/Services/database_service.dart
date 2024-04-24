import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_ranger/Features/Add_Abook/BookModel.dart';

class DatabaseService {
  static late Isar isar;
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([BookModelSchema], directory: dir.path);
  }

  Future<void> addBookModels(BookModel bookModel) async {
    isar.writeTxn(() => isar.bookModels.put(bookModel));
  }

  Future<List<BookModel>> fetchBookModels() async {
    return await isar.bookModels.where().findAll();
  }

  Future<void> updateBookModels({required int id, required Duration duration}) async {
    final existingbook = await isar.bookModels.get(id);
    if (existingbook != null) {
      existingbook.durationMinutes = duration.inMinutes;
      isar.writeTxn(() => isar.bookModels.put(existingbook));
    }
  }

  Future<void> deleteBookModels(int id) async {
    isar.writeTxn(() => isar.bookModels.delete(id));
  }
}
