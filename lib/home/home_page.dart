import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:math_app/main.dart';
import 'package:math_app/shared/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () async {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => Wrapper()));
    });
    super.initState();
  }

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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/math_blog.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black45, Colors.black87]),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "MATH App",
                  style: TextStyle(
                      fontSize: 70.0,
                      color: Colors.white,
                      fontFamily: "EraserDust-p70d"),
                ),
                SizedBox(height: 60.0),
                spinkit
              ],
            ),
          ),
        ],
      ),
    );
  }
}
