import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {

  Future uploadPic(BuildContext context, File image) async{
      String fileName = image.path;
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
       StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      //  setState(() {
      //     print("Profile Picture uploaded");
      //     Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      //  });
    }
  
}
