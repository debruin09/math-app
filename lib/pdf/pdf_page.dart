import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:math_app/models/member.dart';
import 'package:math_app/services/pdf_service.dart';
import 'package:math_app/shared/constants.dart';
import 'package:provider/provider.dart';

class PDFScreen extends StatefulWidget {
  final String url;
  final String name;
  final String group;
  final int duration;

  PDFScreen({this.url, this.name, this.group, this.duration});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  PDFService pdf = PDFService();
  String pathPDF = "";
  bool _isLoading = true;
  PDFDocument _doc;

  Future<PDFDocument> getDoc(url) async {
    final doc = await PDFDocument.fromURL(url);
    return doc;
  }

  @override
  void initState() {
    super.initState();
    getDoc(widget.url).then((doc) {
      setState(() {
        _doc = doc;
        _isLoading = false;
      });
    });
  }

  Future<void> _infoPopUp(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: appBarTheme,
            title: Text(
              "Information",
              style: normalTextTheme,
            ),
            content: Text(
              "Times Up",
              style: normalTextTheme,
            ),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Close",
                    style: normalTextTheme,
                  ))
            ],
          );
        });
  }

  Timer _timer;
  int _start = 5;

  void startTimer(context) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _infoPopUp(context);
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Firestore firestore = Firestore.instance;

    final member = Provider.of<Member>(context);
    if (widget.group != "") {
      DocumentReference firestoreRef =
          firestore.collection("Groups").document(widget.group);

      final groupStream = firestoreRef.snapshots();

      return StreamBuilder<DocumentSnapshot>(
          stream: groupStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final groupmembers = snapshot.data.data["members"];

              List names = groupmembers
                  .map((member) => member["username"].toString())
                  .toList();

              for (int i = 0; i < names.length; i++) {
                if (member.username == names[i]) {
                  return Scaffold(
                    body: Stack(
                      children: <Widget>[
                        PDFViewer(
                          document: _doc,
                          indicatorBackground: Colors.pink[400],
                        ),
                        Positioned(
                          top: 30.0,
                          left: 30.0,
                          child: IconButton(
                            onPressed: () {
                              startTimer(context);
                            },
                            icon: Icon(
                              Icons.play_circle_filled,
                              color: secondaryTheme,
                              size: 50.0,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 160.0,
                          child: Container(
                            alignment: Alignment.center,
                            width: 80.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: appBarTheme,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Text(
                              "$_start",
                              style: normalTextTheme.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }
              return PDFViewer(
                document: _doc,
                indicatorBackground: Colors.pink[400],
              );
            }
            return Center(child: Constants.spinkit);
          });
    }

    return _isLoading == true
        ? Scaffold(
            backgroundColor: appBarTheme,
            appBar: AppBar(
                title: Text("${widget.name}"),
                backgroundColor: appBarTheme,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                ]),
            body: Center(child: Constants.spinkit),
          )
        : PDFViewer(
            document: _doc,
            indicatorBackground: Colors.pink[400],
          );
  }
}
