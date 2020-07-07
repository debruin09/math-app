import 'package:math_app/auth/login_page.dart';
import 'package:math_app/auth/sign_up.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showSignIn = false;

  void toggle() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPage(toggleView: toggle);
    } else {
      return SignUpPage(toggleView: toggle);
    }
  }
}
