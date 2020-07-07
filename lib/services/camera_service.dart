import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CameraService {
  Future takePhoto() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }
}