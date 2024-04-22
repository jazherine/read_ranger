import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:read_ranger/Features/Home/HomeView.dart';
import 'package:read_ranger/Products/Services/database_service.dart';
import 'package:read_ranger/Products/Utility/image_picker.dart';

class AddaBookView extends ConsumerStatefulWidget {
  const AddaBookView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddaBookViewState();
}

class _AddaBookViewState extends ConsumerState<AddaBookView> {
  File? _selectedimageFile;
  final _databaseService = DatabaseService();

  late TextEditingController booknameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booknameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 150,
      ),
      Text(
        "Add Photo",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      SizedBox(
        height: 50,
      ),
      Container(
        child: InkWell(
            onTap: () async {
              ImagePickerS imagePickerS = ImagePickerS();

              File? pickedImage = await imagePickerS.capturePhoto();
              if (pickedImage.path.isNotEmpty) {
                _selectedimageFile = pickedImage;
                setState(() {});
              }
            },
            child: _selectedimageFile == null
                ? Icon(
                    Icons.add_a_photo_outlined,
                    size: 60,
                  )
                : Image.file(
                    _selectedimageFile!,
                    height: 200,
                  )),
      ),
      SizedBox(
        height: 50,
      ),
      // Book Name
      SizedBox(
        width: 250,
        child: TextField(
          maxLength: 15,
          decoration: InputDecoration(
            labelText: "Book Name",
            hintText: "Book Name",
            hintStyle: TextStyle(fontSize: 12),
            labelStyle: TextStyle(fontSize: 15),
          ),
          controller: booknameController,
        ),
      ),
      // Description
      SizedBox(
        width: 250,
        child: TextField(
          maxLength: 15,
          decoration: InputDecoration(
            labelText: "Book Description",
            hintText: "like a brief description of the book",
            hintStyle: TextStyle(fontSize: 12),
            labelStyle: TextStyle(fontSize: 15),
          ),
          controller: descriptionController,
        ),
      ),
      SizedBox(
        height: 50,
      ),

      //  BUTON

      Container(
          width: 250,
          child: ElevatedButton(
            onPressed: () {
              if (booknameController.text.isEmpty || descriptionController.text.isEmpty || _selectedimageFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
                return;
              } else {
                // ref.read(bookModelProvider.notifier).addBookModel(BookModel(
                //       bookName: booknameController.text,
                //       description: descriptionController.text,
                //       imagePath: _selectedimageFile!.path,
                //     ));
                _databaseService.addBookModels(BookModel(
                  bookName: booknameController.text,
                  description: descriptionController.text,
                  imagePath: _selectedimageFile!.path,
                ));
                inspect(_databaseService.fetchBookModels());

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Book Added")));
                ref.watch(selectedIndex.notifier).state = 1;
              }
            },
            child: Icon(Icons.add_outlined),
          ))
    ]);
  }
}
