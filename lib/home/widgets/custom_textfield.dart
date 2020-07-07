import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:math_app/home/group/show_image.dart';
import 'package:math_app/shared/constants.dart';

class CustomeTextField extends StatelessWidget {
  final TextEditingController messageController;
  final File myImage;
  final String username;
  final String groupName;
  final DocumentReference firestoreRef;
  final VoidCallback callback;
  final Function takePhoto;

  CustomeTextField({
    Key key,
    this.myImage,
    this.messageController,
    this.username,
    this.groupName,
    this.firestoreRef,
    this.callback,
    this.takePhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        onSubmitted: (value) => callback(),
        decoration: formTheme.copyWith(
          hintText: "Enter a Message...",
          suffixIcon: IconButton(
              icon: Icon(Icons.camera),
              onPressed: () async {
                await takePhoto();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowImagePage(
                      image: myImage,
                      username: username,
                      groupname: groupName,
                      firestoreRef: firestoreRef,
                    ),
                  ),
                );
              }),
        ),
        controller: messageController,
      ),
    );
  }
}
