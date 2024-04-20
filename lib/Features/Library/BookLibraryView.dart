import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Add_Abook/Add_a_bookProvider.dart';

class BookLibraryView extends ConsumerStatefulWidget {
  const BookLibraryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookLibraryViewState();
}

class _BookLibraryViewState extends ConsumerState<BookLibraryView> {
  @override
  Widget build(BuildContext context) {
    List<BookModel> _bookModel = ref.read(bookModelProvider);

    ref.watch(bookModelProvider);

    return Scaffold(
        body: Center(
      child: ListView.builder(
        itemCount: _bookModel.length,
        itemBuilder: (context, index) {
          return LibraryCard(_bookModel[index]);
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
                      onPressed: () {
                        ref.read(bookModelProvider.notifier).removeBookModel(widget.bookModel.id!);
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
