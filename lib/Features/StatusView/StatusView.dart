import 'package:com.ugurTurker.read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:com.ugurTurker.read_ranger/Features/Library/BookLibraryView.dart';
import 'package:com.ugurTurker.read_ranger/Features/StatusView/StatusProvider.dart';
import 'package:com.ugurTurker.read_ranger/Products/Services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final DatabaseService _databaseService = DatabaseService();

class StatusView extends ConsumerStatefulWidget {
  const StatusView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatusViewState();
}

class _StatusViewState extends ConsumerState<StatusView> {
  Future<void> fetchbookS() async {
    List<BookModel> books = await _databaseService.fetchBookscompletedModels();

    if (mounted) {
      ref.read(unCompletedBooksProvider.notifier).state = books;
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchbookS();

    final _books = ref.watch(unCompletedBooksProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Finished Books",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return LibraryCard(_books[index]);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: _books.length));
  }
}
