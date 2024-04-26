import 'dart:io';

import 'package:com.ugurTurker.read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:com.ugurTurker.read_ranger/Features/CardDetailView/CardDetailView.dart';
import 'package:com.ugurTurker.read_ranger/Features/Home/HomeProvider.dart';
import 'package:com.ugurTurker.read_ranger/Products/Services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final DatabaseService _databaseService = DatabaseService();

class BookLibraryView extends ConsumerStatefulWidget {
  const BookLibraryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookLibraryViewState();
}

class _BookLibraryViewState extends ConsumerState<BookLibraryView> {
  Future<void> fetchbookS() async {
    List<BookModel> books = await _databaseService.fetchBooksUncompletedModels();
    if (mounted) {
      ref.read(bookListStateProvider.notifier).state = books;
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchbookS();

    final _books = ref.watch(bookListStateProvider);

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              " Actively Reading",
              style: Theme.of(context).textTheme.headlineLarge,
            )),
        body: Center(
          child: ListView.builder(
            itemCount: _books.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CardDetailView(
                              bookModel: _books[index],
                            )));
                  },
                  child: LibraryCard(_books[index]));
            },
          ),
        ));
  }
}

class LibraryCard extends ConsumerStatefulWidget {
  const LibraryCard(this.bookModel, {super.key});
  final BookModel bookModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryCardState();
}

class _LibraryCardState extends ConsumerState<LibraryCard> {
  late final File _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = File(widget.bookModel.imagePath!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.bookModel.bookName!),
        leading: Image.file(
          _image,
          height: 60,
        ),
        subtitle: Text(widget.bookModel.description!),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Are you sure to remove this book ?  "),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () async {
                        _databaseService.deleteBookModels(widget.bookModel.id);

                        Navigator.of(context).pop();
                      },
                      child: Text("Yes"),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
