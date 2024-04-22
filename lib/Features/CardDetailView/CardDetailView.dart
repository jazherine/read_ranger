import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:read_ranger/Products/Services/database_service.dart';

class CardDetailView extends ConsumerStatefulWidget {
  const CardDetailView({super.key, required this.bookModel});
  final BookModel bookModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardDetailViewState();
}

class _CardDetailViewState extends ConsumerState<CardDetailView> {
  final _databaseService = DatabaseService();

  late final File _image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = File(widget.bookModel.imagePath!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
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
                              _databaseService.deleteBookModels(widget.bookModel.id);
                              Navigator.of(context).popAndPushNamed("/home");
                            },
                            child: Text("Yes"),
                          )
                        ],
                      ),
                    );
                  },
                  child: Text('Delete This Book ',
                      style: TextStyle(
                        color: Colors.red,
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Image.file(
                _image,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(widget.bookModel.bookName!),
            ),
            Text(widget.bookModel.description!),
          ],
        ),
      ),
    );
  }
}
