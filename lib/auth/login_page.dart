import 'package:math_app/auth/widgets/submit_button.dart';
import 'package:math_app/services/auth_service.dart';
import 'package:math_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  LoginPage({this.toggleView});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> loginUser({BuildContext context, String email, password}) async {
    try {
      final _auth = Provider.of<AuthService>(context, listen: false);
      final user =
          await _auth.signInWithEmail(email: email, password: password);

      if (user == null) {
        setState(() {
          error = "Please supply validate details";
        });
      }
    } catch (e) {
      print("Message: $e");
    }
  }

  String email = "";

  String password = "";

  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
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
            height: 720.0, // MediaQuery.of(context).size.height,
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
                "Login",
                style: TextStyle(
                    fontSize: 70.0,
                    color: Colors.white,
                    fontFamily: "EraserDust-p70d"),
              ),
              SizedBox(height: 80.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
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
                            prefixIcon: Icon(Icons.enhanced_encryption)),
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
              SubmitButton(
                color: Colors.transparent,
                width: 300.0,
                text: "Login",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    return loginUser(
                        context: context, email: email, password: password);
                  }
                },
              ),
              SizedBox(height: 10.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "I don\'t have an account",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: secondaryTheme,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
            ],
          ),
        ]),
      ),
    );
  }
}
