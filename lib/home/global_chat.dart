import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_app/home/widgets/custom_textfield.dart';
import 'package:math_app/home/widgets/message.dart';
import 'package:math_app/home/widgets/send_button.dart';
import 'package:math_app/shared/constants.dart';

import 'group/show_image.dart';

class GlobalChatPage extends StatefulWidget {
  static const String id = "CHAT";
  final String username;
  const GlobalChatPage({Key key, this.username}) : super(key: key);
  @override
  _GlobalChatPageState createState() => _GlobalChatPageState();
}

class _GlobalChatPageState extends State<GlobalChatPage> {
  final Firestore _firestore = Firestore.instance;
  File myImage;

  final spinkit = SpinKitFadingCube(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue[700] : Colors.pink[400],
        ),
      );
    },
  );

  Future takePhoto() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      myImage = image;
      print("This is the image werk nou : $image" ?? "Nothing yet die man");
    });
  }

  static final themeColor = Colors.white;
  // TODO: When user clciks on enter mark it submits answer change that
  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    ScrollController scrollController = ScrollController();

    Future<void> callback() async {
      if (messageController.text.length > 0) {
        print(messageController.text);
        await _firestore.collection('messages').document().setData({
          'text': messageController.text,
          'from': widget.username,
          'date': DateTime.now().toIso8601String().toString(),
           'image': myImage ?? null,
        });
        messageController.clear();
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white70.withOpacity(0.8),
      appBar: AppBar(
        title: Text(
          "Global Chat",
          style: TextStyle(color: Colors.white, fontFamily: "EraserDust-p70d"),
        ),
        backgroundColor: appBarTheme,
        centerTitle: true,
        elevation: 5.0,
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
                      stream: _firestore
                          .collection('messages')
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
                  Container(
                    padding: EdgeInsets.only(bottom: 15.0),
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
                                                    firestoreRef:
                                                        _firestore.collection("messages").document(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
