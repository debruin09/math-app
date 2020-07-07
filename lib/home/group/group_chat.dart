import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_app/home/challenge/create_challenge.dart';
import 'package:math_app/home/group/show_image.dart';
import 'package:math_app/home/widgets/message.dart';
import 'package:math_app/home/widgets/send_button.dart';
import 'package:math_app/shared/constants.dart';

class GroupChatPage extends StatefulWidget {
  static const String id = "CHAT";
  final String username;
  final String groupName;
  final DocumentReference firestoreRef;
  GroupChatPage({
    Key key,
    this.username,
    this.groupName,
    this.firestoreRef,
  }) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  static final themeColor = Colors.white;

  final spinkit = SpinKitFadingCube(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue[700] : Colors.pink[400],
        ),
      );
    },
  );

  // TODO: When user clciks on enter mark it submits answer change that
  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    ScrollController scrollController = ScrollController();
    File myImage;

    Future<void> callback() async {
      if (messageController.text.length > 0) {
        widget.firestoreRef.collection("messages").add({
          'text': messageController.text,
          'image': myImage ?? null,
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
        myImage = image;
        print("This is the image werk nou : $image" ?? "Nothing yet die man");
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.groupName ?? "Group Chat"}",
          style: TextStyle(color: Colors.white, fontFamily: "EraserDust-p70d"),
        ),
        backgroundColor: appBarTheme,
        centerTitle: true,
         actions: <Widget>[
          PopupMenuButton<String>(
              color: tertiaryTheme,
              onSelected: (choice) {
                if (choice == Constants.menu[0])
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateChallengePage(group: widget.groupName,)));
              },
              itemBuilder: (context) {
                return Constants.menu.map((choice) {
                  return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(color: Colors.white),
                      ));
                }).toList();
              })
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.pink[300].withOpacity(0.8),
                    appBarTheme.withOpacity(0.8),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: widget.firestoreRef
                          .collection("messages")
                          .orderBy('date')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: spinkit,
                          );

                        List<DocumentSnapshot> docs = snapshot.data.documents;

                        List<Widget> messages = docs
                            .map((doc) => Message(
                                  from: doc.data['from'],
                                  text: doc.data['text'],
                                  image: doc.data["image"],
                                  me: widget.username == doc.data['from'],
                                ))
                            .toList();

                        return ListView(
                          controller: scrollController,
                          children: <Widget>[
                            ...messages,
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
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
                                                builder: (context) =>
                                                    ShowImagePage(
                                                      image: myImage,
                                                      username: widget.username,
                                                      groupname:
                                                          widget.groupName,
                                                      firestoreRef:
                                                          widget.firestoreRef,
                                                    )));
                                      })),
                              controller: messageController,
                            ),
                          ),
                          SendButton(
                            text: "Send",
                            callback: callback,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
