import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const Color appBarTheme = Color.fromRGBO(58, 66, 86, 1.0);
const Color secondaryTheme = Color(0xFF2CF6B3);
const Color tertiaryTheme = Color.fromRGBO(64, 75, 96, .9);

const formTheme = InputDecoration(
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
  fillColor: Colors.white,
  filled: true,
  focusColor: Colors.white,
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryTheme),
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
);

const textTheme = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
    fontFamily: "SourceSansPro");

const myGroupTextTheme = TextStyle(
  color: appBarTheme,
  fontWeight: FontWeight.bold,
);

const normalTextTheme = TextStyle(
  color: Colors.white,
);

const challengeText = TextStyle(
  color: secondaryTheme,
  fontSize: 20.0,
);

class Constants {
  static List<String> menu = [
    'Create Challenge',
    'Cancel',
  ];

  static final spinkit = SpinKitFadingCube(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue[700] : Colors.pink[400],
        ),
      );
    },
  );
}
