import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImage {
 
   Future chooseFile(File image) async {    
   image = await ImagePicker.pickImage(source: ImageSource.gallery);
   return image;  
 } 
}