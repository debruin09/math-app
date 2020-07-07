import 'package:math_app/auth/widgets/submit_button.dart';
import 'package:math_app/services/auth_service.dart';
import 'package:math_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleView;
  SignUpPage({this.toggleView});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> createTheUser(
      {BuildContext context,
      String username,
      password,
      email,
      bool challenge}) async {
    try {
      final _auth = Provider.of<AuthService>(context, listen: false);
      final user = await _auth.createMember(
          email: email,
          password: password,
          username: username,
          challenge: challenge);

      if (user == null) {
        setState(() {
          error = "Please supply validate details";
        });
      }
      print("uid: ${user.uid}");
    } catch (e) {
      print("Message: $e");
    }
  }

  String username = "";
  String email = "";

  String password = "";

  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 720.0, // MediaQuery.of(context).size.height,
              child: Image.asset(
                "assets/images/algebra.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              height: 720.0, //  MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black87, Colors.black87]),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100.0),
                Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 70.0,
                      color: Colors.white,
                      fontFamily: "EraserDust-p70d"),
                ),
                SizedBox(height: 70.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? "Enter Your Username" : null,
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                          decoration: formTheme.copyWith(
                              hintText: "Username",
                              prefixIcon: Icon(Icons.supervised_user_circle)),
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? "Enter Your Email" : null,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: formTheme.copyWith(
                              hintText: "Email", prefixIcon: Icon(Icons.email)),
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                          obscureText: true,
                          validator: (val) => val.length < 6
                              ? "Enter a Password: + 6 characters"
                              : null,
                          onChanged: (passValue) {
                            setState(() {
                              password = passValue;
                            });
                          },
                          decoration: formTheme.copyWith(
                              hintText: "Paswword",
                              prefixIcon: Icon(
                                Icons.enhanced_encryption,
                                color: Colors.grey,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 10.0),
                SubmitButton(
                  text: "Sign Up",
                  color: Colors.transparent,
                  width: 300.0,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      return createTheUser(
                          context: context,
                          username: username,
                          password: password,
                          challenge: false,
                          email: email);
                    }
                  },
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: secondaryTheme,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
