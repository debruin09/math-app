import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_app/home/widgets/send_button.dart';
import 'package:math_app/shared/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowImagePage extends StatefulWidget {
  final File image;
  final String username;
  final DocumentReference firestoreRef;
  final String groupname;
  ShowImagePage({
    this.image,
    this.username,
    this.groupname,
    this.firestoreRef,
  });

  @override
  _ShowImagePageState createState() => _ShowImagePageState();
}

class _ShowImagePageState extends State<ShowImagePage> {
  final spinkit = SpinKitFadingCube(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? appBarTheme : secondaryTheme,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    ScrollController scrollController = ScrollController();
    File _image;
    dynamic _uploadedFileURL;
    bool _loaded = false;

    Future<void> callback() async {
      if (messageController.text.length > 0) {
        widget.firestoreRef.collection("messages").add({
          'text': messageController.text ?? "",
          'image': _image ?? null,
          'from': widget.username,
          'date': DateTime.now().toIso8601String().toString(),
        });
        messageController.clear();
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    Future takePhoto() async {
      File image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
      });
    }

    Future uploadFile() async {
      try {
        StorageReference storageReference =
            FirebaseStorage.instance.ref().child('chats/${widget.image.path}}');
        StorageUploadTask uploadTask = storageReference.putFile(widget.image);
        await uploadTask.onComplete;
        await storageReference.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL = fileURL;
            _loaded = true;
            print('This is the upload url: $_uploadedFileURL');

            if (_uploadedFileURL != null) {
              widget.firestoreRef.collection("messages").add({
                "date": DateTime.now().toIso8601String().toString(),
                "text": messageController.text ?? "no text",
                "from": widget.username,
                "image": _uploadedFileURL ?? "No url"
              });
              messageController.clear();
            }
          });
        });
      } catch (e) {
        print("Error from upload function: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.groupname ?? "Chat"}",
          style: TextStyle(color: Colors.white, fontFamily: "EraserDust-p70d"),
        ),
        backgroundColor: appBarTheme,
        centerTitle: true,
      ),
      backgroundColor: appBarTheme,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  widget.image != null
                      ? Image.file(
                          widget.image,
                          height: MediaQuery.of(context).size.height - 200.0,
                        )
                      : Center(
                          child: spinkit,
                        ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: TextField(
                            onSubmitted: (value) => callback(),
                            decoration: formTheme.copyWith(
                                hintText: "Enter a Message...",
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.camera),
                                    onPressed: () async {
                                      takePhoto();
                                    })),
                            controller: messageController,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SendButton(
                            text: "Send",
                            callback: () async {
                              await uploadFile();
                              print("File Uploaded successfully");
                              print(
                                  "URL ${_uploadedFileURL ?? "No url recieved"}");
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // loaded == false ? Center(child: spinkit) : Container()
        ],
      ),
    );
  }
}
