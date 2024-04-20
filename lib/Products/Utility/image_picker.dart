import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerS {
  final ImagePicker picker = ImagePicker();

  Future<File> capturePhoto() async {
    final _imageXFile = await picker.pickImage(source: ImageSource.camera);
    if (_imageXFile == null) {
      return File("");
    }
    return File(_imageXFile.path);
  }
}
