import 'dart:io';

import 'package:com.ugurTurker.read_ranger/Features/Add_Abook/BookModel.dart';
import 'package:com.ugurTurker.read_ranger/Features/Home/HomeProvider.dart';
import 'package:com.ugurTurker.read_ranger/Products/Services/database_service.dart';
import 'package:com.ugurTurker.read_ranger/Products/Utility/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late TextEditingController bookPageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booknameController = TextEditingController();
    bookPageController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    booknameController.dispose();
    descriptionController.dispose();
    bookPageController.dispose();
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
      Column(
        children: [
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
              maxLength: 50,
              decoration: InputDecoration(
                labelText: "Description ",
                hintText: "like a brief description of the book",
                hintStyle: TextStyle(fontSize: 12),
                labelStyle: TextStyle(fontSize: 15),
              ),
              controller: descriptionController,
            ),
          ),

          SizedBox(
            width: 250,
            child: TextField(
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Page of the book",
                hintText: " Enter the number of pages of the book",
                hintStyle: TextStyle(fontSize: 12),
                labelStyle: TextStyle(fontSize: 15),
              ),
              controller: bookPageController,
            ),
          ),

          //  BUTON

          Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  if (booknameController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      _selectedimageFile == null ||
                      bookPageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
                    return;
                  } else {
                    _databaseService.addBookModels(BookModel(
                      bookPages: bookPageController.text,
                      bookName: booknameController.text,
                      description: descriptionController.text,
                      imagePath: _selectedimageFile!.path,
                    ));

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Book Added")));
                    if (mounted) {
                      ref.watch(selectedIndex.notifier).state = 1;
                    }
                  }
                },
                child: Icon(Icons.add_outlined),
              )),
        ],
      )
    ]);
  }
}
